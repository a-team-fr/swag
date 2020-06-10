/****************************************************************************
**
** Copyright (C) 2020 A-Team.
** Contact: https://a-team.fr/
**
** This file is part of the SwagSoftware free project.
**
**  SwagSoftware is free software: you can redistribute it and/or modify
**  it under the terms of the GNU General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**  SwagSoftware is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU General Public License for more details.
**
**  You should have received a copy of the GNU General Public License
**  along with SwagSoftware.  If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/
#ifndef NETWORKING_H
#define NETWORKING_H

#include <QObject>
#include <QWebSocketServer>
#include <QWebSocket>
#include <QSettings>
#include <QFile>
#include <QNetworkAccessManager>

class SingletonQNam{
    static QNetworkAccessManager* m_nam;
public:
    static QNetworkAccessManager* qnam() {
        if (!m_nam)
            m_nam  = new QNetworkAccessManager;
        return m_nam;
    }
    ~SingletonQNam(){
        if (m_nam)
            delete m_nam;
        m_nam = nullptr;
    }
};

class UploadJob : public QObject
{
    Q_OBJECT
public:
    UploadJob(const QString& localfilePath , const QString& remotDocName, QObject* parent = nullptr);
    ~UploadJob();

//public slots:
    //QIODevice* data(){ return &m_localFile;}


signals :
    void finish(const QUrl& url);
    void failed(QString);
    void progressed( const QString& localfilePath, qint64 percProgress);

protected:
     void timerEvent(QTimerEvent *event) override;

private slots:
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadFinished();

private:
    QSettings m_settings;
    QUrl m_url;
    QFile m_localFile;
    QNetworkReply* nr = nullptr;

};


class DownloadJob : public QObject
{
    Q_OBJECT
public:
    DownloadJob(const QUrl& url, const QString& localfilePath );
signals :
    void finish(const QString& localFilePath);
    void failed(QString);
    void progressed( const QString& localfilePath, qint64 percProgress);
private slots:
    void downloadProgress(qint64 bytesSent, qint64 bytesTotal);
    void downloadFinished();
private:
    QUrl m_url;
    QString m_localFilePath;
};




/**
 * @brief The WSServer class - a ws server which can be conveniently used on local network
 *
 * usage : call startServer optionnaly providing a port number. The connection URL can be retrieved with serverUrl
 */
class WSServer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool serverRunning READ serverRunning NOTIFY serverRunningChanged)
    Q_PROPERTY(QString serverUrl READ serverUrl NOTIFY serverRunningChanged)

public:
    enum WS_ActionsType{ WS_HISTORY = 1, WS_HELLO, WS_MESSAGE, WS_CHANNEL, WS_CLIENTS, WS_DOCUMENT};
    Q_ENUM(WS_ActionsType)

    explicit WSServer( QObject *parent = nullptr);
    ~WSServer();

public slots:
    /**
     * @brief startServer - create a (non secured) ws server and start listening on the given port on all available interfaces
     * @param portNumber : the desired portNumber or 0 for automatic selection
     */
    void startServer(uint portNumber);
    /**
     * @brief stopServer -
     */
    void stopServer();
    /**
     * @brief sendToClients - send to the desired clients a request to process the given action with the given data
     * @param clients - the list of connected ws clients the request is to be sent to
     * @param action - the WS_ActionsType
     * @param data - the data as a Json array or object to perform the action
     */
    void sendToClients(const QList<QWebSocket*>& WS_CLIENTS, WS_ActionsType action, const QJsonValue& data);
    /**
     * @brief sendToChannel - same as sendToClients but sending to all clients of the given channel
     * @param channel - the channel
     */
    void sendToChannel(const QString& WS_CHANNEL, WS_ActionsType action, const QJsonValue& data, QWebSocket* excludeSender = nullptr);
    void sendToClient( QWebSocket* client, WS_ActionsType action, const QJsonValue& data);

signals:
    void serverRunningChanged();
    void lstClientsChanged();

private slots:
    void onNewConnection();
    void textMessageReceived(QString WS_MESSAGE);
    void binaryMessageReceived(QByteArray WS_MESSAGE);
    void socketDisconnected();
    bool serverRunning() const { return m_pWSServer; }


private:
    /**
     * @brief processAction - common method called to process an action received textMessageReceived or binaryMessageReceived
     * @param pSender - the WS client that sent the action
     * @param action - the action requested
     * @param data - the action data content
     * @return true on success
     */
    bool processAction(QWebSocket * pSender, WSServer::WS_ActionsType action, const QJsonValue &data);
    /**
     * @brief channelHistory - get the history filtered by channel
     *
     * @param channel
     * @return
     */
    QJsonValue channelHistory( const QString& WS_CHANNEL) const;
    QJsonValue channelClients( const QString& WS_CHANNEL) const;
    QJsonValue channels( ) const;
    QString serverUrl() const;
    QWebSocketServer *m_pWSServer = nullptr;
    QMap<QWebSocket *, QVariantMap> m_clients;                      /// list of currently connected clients

    QStringList colors{"red","green","blue","magenta","purple","plum","orange"};
    uint m_lastUsedColors = 0;
    QVariantList lastMessages;


};


class WSClient : public QObject
{
    Q_OBJECT

    Q_PROPERTY(WSServer* localServer MEMBER m_pServer NOTIFY connectedChanged)
    Q_PROPERTY(bool connected MEMBER m_bIsConnected NOTIFY connectedChanged)
    Q_PROPERTY(QString me MEMBER m_alias NOTIFY aliasChanged)
    Q_PROPERTY(QUrl url MEMBER m_WSHostUrl NOTIFY clientRunningChanged)
    Q_PROPERTY(QUrl lastWSConnectionUrl READ lastWSConnectionUrl NOTIFY clientRunningChanged)
    Q_PROPERTY(bool clientRunning READ clientRunning NOTIFY clientRunningChanged)
    Q_PROPERTY(bool presenting MEMBER m_isPresenting NOTIFY channelChanged)
    Q_PROPERTY(bool following READ following NOTIFY channelChanged)
    Q_PROPERTY(QString channel MEMBER m_channel NOTIFY channelChanged)
    Q_PROPERTY(QVariantList lstConnectedClients MEMBER m_lstConnectedClients NOTIFY lstClientsChanged)
    Q_PROPERTY(QVariantList lstMessage MEMBER m_lstMessage NOTIFY receivedChatMessage)
    Q_PROPERTY(QVariantList lstChannels MEMBER m_lstChannels NOTIFY lstChannelsChanged)



public:
    enum WS_ActionsType{ WS_HISTORY = 1, WS_HELLO, WS_MESSAGE, WS_CHANNEL, WS_CLIENTS, WS_DOCUMENT};
    Q_ENUM(WS_ActionsType)


    explicit WSClient(QObject *parent = nullptr);
    ~WSClient();



public slots:
    void startClient(const QUrl &url);
    void stopClient();
    void onLoginChanged(uint userId, const QString& userAlias);
    void notifyDocumentPositionChanged();
    void sendActionToServer(WS_ActionsType action, const QJsonValue& data);
    void sendMessage( const QString& WS_MESSAGE);
    void modifyChannel( const QString& channelId, bool isPresenter);


signals:
    void clientRunningChanged();
    void aliasChanged();
    void lstClientsChanged();
    void connectedChanged();
    void receivedChatMessage( QVariant msg);
    void lstChannelsChanged();
    void channelChanged();

private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(QString WS_MESSAGE);
    void onBinaryMessageReceived(QByteArray WS_MESSAGE);
    bool clientRunning() const { return m_pWSClient; }

private:
    QUrl lastWSConnectionUrl() const;
    bool following() const{ return m_channel != "0"; }
    bool isChannelExists(const QString& channelName) const;
    bool processMessage(WS_ActionsType action, const QJsonValue& data);
    bool m_bIsConnected = false;                /// when the client is connected
    QSettings m_settings;
    QWebSocket* m_pWSClient = nullptr;
    WSServer* m_pServer = nullptr;
    QUrl m_WSHostUrl{};
    QString m_alias ="";
    uint m_userId = 0;
    bool m_isPresenting = false;
    QString m_channel = "0";
    QVariantList m_lstConnectedClients{};
    QVariantList m_lstMessage{};
    QVariantList m_lstChannels{};
    QUrl m_currentDocumentURL{};

};

#endif // NETWORKING_H
