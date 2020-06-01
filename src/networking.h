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
    enum WS_ActionsType{ history = 1, hello, message, channel, clients};
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
    void sendToClients(const QList<QWebSocket*>& clients, WS_ActionsType action, const QJsonValue& data);
    /**
     * @brief sendToChannel - same as sendToClients but sending to all clients of the given channel
     * @param channel - the channel
     */
    void sendToChannel(const QString& channel, WS_ActionsType action, const QJsonValue& data);
    void sendToClient( QWebSocket* client, WS_ActionsType action, const QJsonValue& data);

signals:
    void serverRunningChanged();
    void lstClientsChanged();

private slots:
    void onNewConnection();
    void textMessageReceived(QString message);
    void binaryMessageReceived(QByteArray message);
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
    QJsonValue channelHistory( const QString& channel) const;
    QJsonValue channelClients( const QString& channel) const;
    QString serverUrl() const;
    QWebSocketServer *m_pWSServer = nullptr;
    QMap<QWebSocket *, QVariantMap> m_clients;                      /// list of currently connected clients

    QStringList colors{"red","green","blue","magenta","purple","plum","orange"};
    uint m_lastUsedColors = 0;
    QVariantList lastMessages;


};


class Networking : public QObject
{
    Q_OBJECT

    Q_PROPERTY(WSServer* localServer MEMBER m_pServer NOTIFY connectedChanged)
    Q_PROPERTY(bool connected MEMBER m_bIsConnected NOTIFY connectedChanged)
    Q_PROPERTY(QString me MEMBER m_alias NOTIFY aliasChanged)
    Q_PROPERTY(QUrl url MEMBER m_url NOTIFY clientRunningChanged)
    Q_PROPERTY(QUrl lastWSConnectionUrl READ lastWSConnectionUrl NOTIFY clientRunningChanged)
    Q_PROPERTY(bool clientRunning READ clientRunning NOTIFY clientRunningChanged)
    Q_PROPERTY(QVariantList lstConnectedClients MEMBER m_lstConnectedClients NOTIFY lstClientsChanged)
    Q_PROPERTY(QVariantList lstMessage MEMBER m_lstMessage NOTIFY receivedChatMessage)


public:
    enum WS_ActionsType{ history = 1, hello, message, channel, clients};
    Q_ENUM(WS_ActionsType)


    explicit Networking(QObject *parent = nullptr);
    ~Networking();



public slots:
    void startClient(const QUrl &url);
    void stopClient();
    void onLoginChanged(uint userId, const QString& userAlias);
    void sendActionToServer(WS_ActionsType action, const QJsonValue& data);
    void sendMessage( const QString& message);
    void modifyChannel( const QString& channelId, bool isPresenter);


signals:
    void clientRunningChanged();
    void aliasChanged();
    void lstClientsChanged();
    void connectedChanged();
    void receivedChatMessage( QVariant msg);

private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(QString message);
    void onBinaryMessageReceived(QByteArray message);
    bool clientRunning() const { return m_pWSClient; }

private:
    QUrl lastWSConnectionUrl() const;
    bool processMessage(WS_ActionsType action, const QJsonValue& data);
    bool m_bIsConnected = false;                /// when the client is connected
    QSettings m_settings;
    QWebSocket* m_pWSClient = nullptr;
    WSServer* m_pServer = nullptr;
    QUrl m_url;
    QString m_alias ="";
    uint m_userId = 0;
    QVariantList m_lstConnectedClients;
    QVariantList m_lstMessage;

};

#endif // NETWORKING_H
