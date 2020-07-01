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
#include "networking.h"
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkInterface>
#include <QCborValue>
#include "prezmanager.h"

QNetworkAccessManager* SingletonQNam::m_nam = nullptr;

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// UploadJob ///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
UploadJob::UploadJob(const QString &localfilePath, const QString &remoteDocName, QObject* parent):QObject(parent), m_localFile(localfilePath)
{

    //QFileInfo inf (localfilePath);
    //qDebug() << inf.size();
    //qDebug() << inf.exists();

    if (! m_localFile.open(QIODevice::ReadOnly)){
        QString error = tr("error reading file %1").arg( localfilePath);
        emit failed( error);
        qDebug() << error;
        deleteLater();
    }
    else{
        m_url = remoteDocName;
        m_url.setScheme("ftp");

        m_url.setHost( m_settings.value("ftpHost", "ftp.swagsoftware.net").toString() );
        m_url.setUserName( m_settings.value("ftpUser", "swagapp@swagsoftware.net").toString());
        m_url.setPassword( m_settings.value("ftpPassword", "eWbsKg7~Kh^@").toString());
        m_url.setPort( m_settings.value("ftpPort", 21).toInt() );
        m_url.setPath("/"+remoteDocName);

        QNetworkReply* reply = SingletonQNam::qnam()->put( QNetworkRequest( m_url ), &m_localFile );
        nr = reply;
        connect(reply, &QNetworkReply::finished, this, &UploadJob::uploadFinished);
        connect(reply, &QNetworkReply::uploadProgress, this, &UploadJob::uploadProgress);

    }

}

UploadJob::~UploadJob()
{
    if ( m_localFile.isOpen())
        m_localFile.close();

}



void UploadJob::uploadFinished()
{
    qDebug() << "upload finished";
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply && reply->error() == QNetworkReply::NoError)
    {
        emit finish( m_url );
        qDebug() << tr("Success uploading %1 to %2").arg( m_localFile.fileName()).arg(m_url.toDisplayString()) ;
    }
    else {
        emit failed( tr("ERROR uploading file %1 with error :%2").arg( m_localFile.fileName()).arg(reply->errorString()) );
        qDebug() << reply->errorString();
    }

    reply->deleteLater();

    deleteLater();

}

void UploadJob::uploadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    if (bytesTotal==0 ) return;
    emit progressed( m_localFile.fileName(), 100 * bytesSent / bytesTotal);
    qDebug() << QString("Sending %1 : %2 / %3").arg(m_localFile.fileName()).arg(bytesSent).arg(bytesTotal);
    if (bytesSent == bytesTotal)
    {
        QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
        qDebug() << "isFinished : " << reply->isFinished();
        startTimer(1000);
    }

}

void UploadJob::timerEvent(QTimerEvent *event)
{
    if (nr && nr->isFinished())
        killTimer( event->timerId());
    else
    qDebug() << "still not finished !";
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// DownloadJob ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

DownloadJob::DownloadJob(const QUrl &url, const QString &localfilePath):m_url(url), m_localFilePath(localfilePath)
{
    QFileInfo fileinfo( m_localFilePath );
    QDir dir( fileinfo.path() );

    //ensure directory exists
    if (!dir.exists())
    {
        dir.mkpath( fileinfo.path() );
        qDebug()<< "create directory:" << fileinfo.path();
    }

    QNetworkRequest request(url);
    QNetworkReply* reply = SingletonQNam::qnam()->get(request);

    connect(reply, &QNetworkReply::finished, this, &DownloadJob::downloadFinished);
    connect(reply, &QNetworkReply::downloadProgress, this, &DownloadJob::downloadProgress);
    //connect(reply, &QNetworkReply::errorOccurred, this, [=](QNetworkReply::NetworkError code){ qDebug() << "Download error : " << code;});
}

void DownloadJob::downloadProgress(qint64 bytesSent, qint64 bytesTotal)
{
    if (bytesTotal==0 ) return;
    emit progressed( m_localFilePath, 100 * bytesSent / bytesTotal);
    qDebug() << QString("receiving %1 : %2 / %3").arg(m_url.toString()).arg(bytesSent).arg(bytesTotal);
}

void DownloadJob::downloadFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply && reply->error() == QNetworkReply::NoError)
    {
        if (reply->bytesAvailable() > 0)
        {
            //int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            //if( httpStatusCode == 200 ) {
                QFile file( m_localFilePath);
                if ( !file.open(QIODevice::WriteOnly ) )
                    emit failed( tr("File error : cannot open file %1").arg(m_localFilePath) );
                if ( file.write( reply->readAll() ) == -1)
                    emit failed( tr("File error : cannot write file %1").arg(m_localFilePath) );
                emit finish( m_localFilePath );
                file.deleteLater();
            //} else emit failed( tr("download error %1").arg(httpStatusCode) );
        }
    } else emit failed( tr("ERROR loading file %1 with error :%2").arg(m_localFilePath).arg(reply->errorString()) );

    reply->deleteLater();

    deleteLater();

}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// WSServer ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

WSServer::WSServer(QObject *parent): QObject(parent)
{

}
WSServer::~WSServer()
{
    if ( serverRunning() )
        stopServer();
}

void WSServer::startServer(uint portNumber)
{
    if ( serverRunning() )
        stopServer();

    m_pWSServer = new QWebSocketServer(QStringLiteral("Swag WS Server"), QWebSocketServer::NonSecureMode, this);
    if (m_pWSServer->listen(QHostAddress::Any, portNumber))
    {
        qDebug() << "WS Swag listening on port" << portNumber;
        connect(m_pWSServer, &QWebSocketServer::newConnection, this, &WSServer::onNewConnection);
        connect(m_pWSServer, &QWebSocketServer::closed, this, &WSServer::serverRunningChanged);
    }


    emit serverRunningChanged();
}

void WSServer::stopServer()
{
    if ( !serverRunning() ) return;

    m_pWSServer->close();
    for (QWebSocket* client : m_clients.keys())
        delete client;

    delete m_pWSServer;

    m_pWSServer = nullptr;
    emit serverRunningChanged();
}

void WSServer::onNewConnection()
{
    QWebSocket *pSocket = m_pWSServer->nextPendingConnection();
    if (!pSocket) return;

    connect( pSocket, &QWebSocket::textMessageReceived, this, &WSServer::textMessageReceived);
    connect( pSocket, &QWebSocket::binaryMessageReceived, this, &WSServer::binaryMessageReceived);
    connect( pSocket, &QWebSocket::disconnected, this, &WSServer::socketDisconnected);

    //Send back history to the new client
    sendToClient( pSocket, WS_ActionsType::WS_HISTORY, channelHistory("0") );
    //Send the list of channel
    sendToClient( pSocket, WS_ActionsType::WS_CHANNEL, channels() );

    QVariantMap client;
    client["userName"]="";
    client["userColor"]="";
    client["userId"]="";
    client["channel"]="0";
    client["presenter"]= false;
    m_clients[pSocket] = client;
    emit lstClientsChanged();
}


void WSServer::textMessageReceived(QString message)
{
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
    if (!pSender) return;
    qDebug() << "Message received by server :" << message.toUtf8();

    QJsonDocument doc = QJsonDocument::fromJson( message.toUtf8());
    QJsonObject obj = doc.object();
    if ( obj.contains("type") && obj.contains("data"))
    {
        processAction( pSender, static_cast<WS_ActionsType>( obj["type"].toInt()), obj["data"]);
    }
    else {
        qWarning("invalid text message received");
    }

}

void WSServer::binaryMessageReceived(QByteArray message)
{
    QWebSocket *pSender = qobject_cast<QWebSocket *>(sender());
    if (!pSender) return;
    qDebug() << "binary message received:" << message;

    QJsonObject obj = QCborValue(message).toJsonValue().toObject();
    if ( obj.contains("type") && obj.contains("data"))
    {
        processAction( pSender, static_cast<WS_ActionsType>( obj["type"].toInt()), obj["data"]);
    }
    else {
        qWarning("invalid binary message received");
    }

}


bool WSServer::processAction(QWebSocket* pSender, WSServer::WS_ActionsType action, const QJsonValue &data)
{
    if (! m_clients.contains(pSender)){
        qWarning() << "unknown client";
        return false;
    }
    QJsonObject msg;
    QDateTime time = QDateTime::currentDateTime();

    QVariantMap senderInfo = m_clients[pSender];

    QString channel = senderInfo["channel"].toString();

    switch(action)
    {
    case WS_ActionsType::WS_CHANNEL:
        if ( (senderInfo["channel"].toString() != "0") && (data["channel"].toString()=="0") && ( senderInfo["presenter"].toBool() ) )
            m_lstPresentingDocuments.remove(senderInfo["channel"].toString());
        senderInfo["channel"] = data["channel"];
        senderInfo["presenter"] = data["presenter"];
        m_clients[pSender] = senderInfo;
        //send channel clients to old channel
        sendToChannel( channel, WS_ActionsType::WS_CLIENTS, channelClients(channel) );
        //send channel clients to current channel
        channel = data["channel"].toString();
        sendToChannel( channel, WS_ActionsType::WS_CLIENTS, channelClients(channel) );
        //Send to everyone the new channel list
        sendToClients( m_clients.keys(), WS_ActionsType::WS_CHANNEL, channels() );
        //send to sender the history
        sendToClient( pSender, WS_ActionsType::WS_HISTORY, channelHistory(channel) );
        //Send to sender the current document position
        if ( (senderInfo["channel"].toString() != "0") && ( !senderInfo["presenter"].toBool() ) && m_lstPresentingDocuments.contains( channel))
            sendToClient( pSender, WS_ActionsType::WS_HISTORY, m_lstPresentingDocuments[ channel]);

        break;
    case WS_ActionsType::WS_MESSAGE:
        //build message
        msg["time"] = time.toString();
        msg["text"] = data["message"];
        msg["userName"] = senderInfo["userName"].toString();
        msg["userId"] = senderInfo["userId"].toString();
        msg["userColor"] = senderInfo["userColor"].toString();
        msg["channel"] = senderInfo["channel"].toString();
        //save message in history for newly connected clients
        if (lastMessages.length() > 100)
            lastMessages.pop_front();
        lastMessages.push_back( msg);
        //send message to all channel clients
        sendToChannel( channel, WS_ActionsType::WS_MESSAGE, msg );

        break;
    case WS_ActionsType::WS_HELLO:
        senderInfo["userName"] = data["userName"];
        senderInfo["userId"] = data["userId"];
        senderInfo["userColor"] = colors[m_lastUsedColors++ % colors.length()];
        m_clients[pSender] = senderInfo;
        //send back to channel clients the list of channel clients
        sendToChannel( channel, WS_ActionsType::WS_CLIENTS, channelClients(channel) );
        break;
     //Simple forward to channel
    case WS_ActionsType::WS_DOCUMENT:
        m_lstPresentingDocuments.insert(channel, data);
        sendToChannel( channel, action, data, pSender );
        break;
    //Actions not relevant for server
    case WS_ActionsType::WS_CLIENTS:
    case WS_ActionsType::WS_HISTORY:
        qDebug() << "invalid actions:" << action << " with data:" << data;

    }
    return true;
}



void WSServer::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    qDebug() << "socketDisconnected:" << pClient;
    if (pClient) {
        QString channel = m_clients[pClient]["channel"].toString();
        bool isPresenter = m_clients[pClient]["presenter"].toBool();
        if ( isPresenter &&  channel != "0")
            m_lstPresentingDocuments.remove(channel);

        m_clients.remove(pClient);
        pClient->deleteLater();
        emit lstClientsChanged();
        if (m_clients.isEmpty())
            lastMessages.clear();
        //send back to channel clients the list of channel clients
        sendToChannel( channel, WS_ActionsType::WS_CLIENTS, channelClients(channel) );
        //Send to everyone the new channel list
        sendToClients( m_clients.keys(), WS_ActionsType::WS_CHANNEL, channels() );

    }
}

void WSServer::sendToChannel(const QString& channel, WS_ActionsType action, const QJsonValue& data,  QWebSocket* excludeSender )
{
    //List of recipients
    QList<QWebSocket*> lstRecipients;
    for (QWebSocket* client : m_clients.keys())
    {
        if ( client != excludeSender && channel == m_clients[client]["channel"].toString() )
            lstRecipients.push_back(client);
    }

    sendToClients(lstRecipients, action, data);

}

void WSServer::sendToClients(const QList<QWebSocket *> &clients, WSServer::WS_ActionsType action, const QJsonValue &data)
{
    QJsonDocument doc;
    QJsonObject obj;
    obj["type"]=action;
    obj["data"]= data;
    doc.setObject(obj);

    //Binary sending
//    QCborValue cbor = QCborValue::fromJsonValue(obj);
//    for (auto recipient : lstRecipients)
//        recipient->sendBinaryMessage( cbor.toByteArray() );

    for (auto recipient : clients)
        recipient->sendTextMessage( doc.toJson() );

}

void WSServer::sendToClient(QWebSocket *client, WSServer::WS_ActionsType action, const QJsonValue &data)
{
    QList<QWebSocket *> clients;
    clients.push_back(client);
    sendToClients( clients, action, data);
}

QJsonValue WSServer::channelHistory(const QString &channel) const
{
    QJsonArray lstMsg;
    for (QVariant msg : lastMessages)
    {
        if (msg.toMap()["channel"] == channel)
            lstMsg.push_back( QJsonValue::fromVariant(msg) );
    }
    return lstMsg;
}

QJsonValue WSServer::channelClients(const QString &channel) const
{
    QJsonArray lstClients;
    for (QVariantMap client : m_clients)
    {
        if ( client["channel"] == channel)
            lstClients.push_back( QJsonValue::fromVariant(client) );
    }
    return lstClients;
}

QJsonValue WSServer::channels() const
{
    QJsonArray LstChannels;
    for (QVariantMap client : m_clients)
    {
        if ( client["presenter"].toBool() )
        {
            QJsonObject channel;
            channel["channel"]= client["channel"].toString();
            channel["owner"]= client["userName"].toString();
            LstChannels.push_back( channel );
        }
    }
    return LstChannels;
}

QString WSServer::serverUrl() const
{
    if (!serverRunning()) return "";
    QString ipv4addr;
    const QHostAddress &localhost = QHostAddress(QHostAddress::LocalHost);
    for (const QHostAddress &address: QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != localhost)
             ipv4addr = address.toString();
    }
    if (ipv4addr.isEmpty())
        return m_pWSServer->serverUrl().toString();

    QString prefix = m_pWSServer->secureMode() == QWebSocketServer::NonSecureMode ? "ws":"wss";

    return QString("%1://%2:%3").arg(prefix).arg( ipv4addr).arg(m_pWSServer->serverPort());
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// WSClient ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
WSClient::WSClient(QObject *parent) : QObject(parent)
{
    m_pServer = new WSServer(parent);
}

WSClient::~WSClient()
{
    if ( clientRunning() )
        stopClient();
}

void WSClient::startClient(const QUrl &url)
{
    if ( clientRunning() )
        stopClient();

    m_WSHostUrl = url;
    m_pWSClient = new QWebSocket();
    emit clientRunningChanged();

    connect( m_pWSClient, &QWebSocket::connected, this, &WSClient::onConnected);
    connect( m_pWSClient, &QWebSocket::disconnected, this, &WSClient::onDisconnected);
    connect( m_pWSClient, &QWebSocket::textMessageReceived, this, &WSClient::onTextMessageReceived);
    connect( m_pWSClient, &QWebSocket::binaryMessageReceived, this, &WSClient::onBinaryMessageReceived);
    connect( m_pWSClient, &QWebSocket::sslErrors, this, [=](){ qDebug()<< m_pWSClient->errorString();});
    connect( m_pWSClient, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error), this, [=](){ qDebug()<< m_pWSClient->errorString(); });

    m_pWSClient->open(QUrl(url));

    //save url as last used (we don't want to save local server url)
    if (!m_pServer)
        m_settings.setValue("lastWSConnectionUrl", url);

}

void WSClient::stopClient()
{
    if ( !clientRunning() ) return;

    m_pWSClient->close();
    delete m_pWSClient;
    m_pWSClient = nullptr;
    //m_pWSClient->deleteLater() ;
    emit clientRunningChanged();
}

QUrl WSClient::lastWSConnectionUrl() const{
    return m_settings.value("lastWSConnectionUrl", "ws://swagsoftware.alwaysdata.net/:8100").toUrl();
}

void WSClient::onLoginChanged(uint userId, const QString& userAlias)
{
    qDebug() << "now logged in as " <<  userAlias << " and id:" << userId;
    m_alias = userAlias;
    m_userId = userId;

    if (userId > 0)
        startClient( lastWSConnectionUrl()  );
    else stopClient();
    emit aliasChanged();
}

void WSClient::notifyDocumentPositionChanged()
{
    PrezManager *pSender = qobject_cast<PrezManager *>(sender());
    if (!pSender || !m_isPresenting) return;

    //get current document position
    QDir docLocalPath = pSender->property("currentSlideDeckPath").toString();
    QString documentName = docLocalPath.dirName();
    int slideIdx = pSender->property("slideSelected").toInt();
    QUrl uploadURL = pSender->property("uploadURL").toUrl();

    //upload document if it is not already done
    if (uploadURL.isEmpty() && !documentName.isEmpty())
            pSender->uploadPrez();

    QJsonObject obj;
    obj["docUrl"] = QJsonValue::fromVariant( uploadURL);
    obj["slideIdx"] = slideIdx;
    sendActionToServer(WS_ActionsType::WS_DOCUMENT, obj);

}

void WSClient::sendActionToServer(WSClient::WS_ActionsType action, const QJsonValue& data)
{
    if (!m_bIsConnected) return;
    QJsonDocument doc;
    QJsonObject obj;
    obj["type"]=action;
    obj["data"]= data;
    doc.setObject(obj);

    //m_pWSClient->sendBinaryMessage( doc.toBinaryData() );
    m_pWSClient->sendTextMessage( doc.toJson() );

}

void WSClient::sendMessage(const QString &message)
{
    if (!m_bIsConnected) return;

    QJsonObject obj;
    obj["message"] = message;


    sendActionToServer(WS_ActionsType::WS_MESSAGE, obj);

}

void WSClient::modifyChannel(const QString &channelId, bool isPresenter)
{
    if (!m_bIsConnected) return;

    QJsonObject obj;
    obj["channel"] = channelId;
    obj["presenter"] = isPresenter;

    m_isPresenting = isPresenter;
    m_channel = channelId;
    emit channelChanged();

    sendActionToServer(WS_ActionsType::WS_CHANNEL, obj);

}

void WSClient::onConnected()
{
    /*
    qDebug() << "WebSocket connected";
    qDebug() << "peerName:"<< m_pWSClient->peerName();
    qDebug() << "peerAddress:"<< m_pWSClient->peerAddress();
    qDebug() << "localAddress:"<< m_pWSClient->localAddress();
    qDebug() << "resourceName:"<< m_pWSClient->resourceName();
    qDebug() << "peerPort:"<< m_pWSClient->peerPort();
    qDebug() << "isValid:" << m_pWSClient->isValid();
    */

    m_bIsConnected = true;
    emit connectedChanged();
    QJsonObject data;
    data["userName"]= m_alias;
    data["userId"]= static_cast<int>(m_userId);
    sendActionToServer(WS_ActionsType::WS_HELLO, data);
    //sendTextMessage(data);

}

void WSClient::onDisconnected()
{
    qDebug() << "WebSocket disconnected";
    m_bIsConnected = false;
    emit connectedChanged();

    m_isPresenting = false;
    m_channel = "0";
    emit channelChanged();

}

void WSClient::onTextMessageReceived(QString message)
{
    //qDebug() << "Message received:" << message;

    QJsonDocument doc = QJsonDocument::fromJson( message.toUtf8());
    QJsonObject obj = doc.object();
    if ( obj.contains("type") && obj.contains("data"))
    {
        processMessage( static_cast<WS_ActionsType>( obj["type"].toInt()), obj["data"]);
    }
    else {
        qWarning("invalid text message received");
    }

}

void WSClient::onBinaryMessageReceived(QByteArray message)
{
    qDebug() << "binary message received:" << message;

    QJsonObject obj = QCborValue(message).toJsonValue().toObject();
    if ( obj.contains("type") && obj.contains("data"))
    {
        processMessage( static_cast<WS_ActionsType>( obj["type"].toInt()), obj["data"]);
    }
    else {
        qWarning("invalid binary message received");
    }

}

bool WSClient::isChannelExists(const QString& channelName) const{
    for (QVariant channel : m_lstChannels )
    {
        if (channel.toJsonObject().value("channel") == channelName)
            return true;
    }
    return false;
}

bool WSClient::processMessage(WSClient::WS_ActionsType action, const QJsonValue &data)
{
    PrezManager *pm = qobject_cast<PrezManager *>(parent());
    QUrl docUrl;

    switch(action)
    {
    case WS_ActionsType::WS_HISTORY:
        m_lstMessage.clear();
        for (QJsonValue c : data.toArray() )
            m_lstMessage.append( c );
        emit receivedChatMessage( data );
        break;
    case WS_ActionsType::WS_MESSAGE:
        m_lstMessage.append( data );
        emit receivedChatMessage( data );
        break;
    case WS_ActionsType::WS_CLIENTS:
        m_lstConnectedClients.clear();
        for (QJsonValue c : data.toArray() )
            m_lstConnectedClients.append(c);
        emit lstClientsChanged();
        break;
    case WS_ActionsType::WS_CHANNEL:
        m_lstChannels.clear();
        for (QJsonValue c : data.toArray() )
            m_lstChannels.append(c);
        emit lstChannelsChanged();
        //check if the current channel is no longer existing
        if ( m_channel != "0" && !isChannelExists( m_channel ) )
            modifyChannel("0", false);

        break;
    case WS_ActionsType::WS_DOCUMENT:
        if (!m_isPresenting){
        docUrl = data["docUrl"].toVariant().toUrl();
        if (docUrl.isEmpty())
            pm->unload();
        else if (pm->property("uploadURL").toUrl() != docUrl)
            pm->downloadPrez( docUrl, data["slideIdx"].toInt());
        else pm->selectSlide( data["slideIdx"].toInt());

        }
        break;
    default:
        qDebug() << "invalid actions:" << action << " with data:" << data;

    }
    return true;
}

