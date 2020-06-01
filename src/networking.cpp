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
    sendToClient( pSocket, WS_ActionsType::history, channelHistory("0") );

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
    case WS_ActionsType::channel:
        senderInfo["channel"] = data["channel"];
        senderInfo["presenter"] = data["presenter"];
        m_clients[pSender] = senderInfo;
        //send channel clients to old channel
        sendToChannel( channel, WS_ActionsType::clients, channelClients(channel) );
        //send channel clients to current channel
        channel = data["channel"].toString();
        sendToChannel( channel, WS_ActionsType::clients, channelClients(channel) );
        //send to sender the history
        sendToClient( pSender, WS_ActionsType::history, channelHistory(channel) );
        break;
    case WS_ActionsType::message:
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
        sendToChannel( channel, WS_ActionsType::message, msg );

        break;
    case WS_ActionsType::hello:
        senderInfo["userName"] = data["userName"];
        senderInfo["userId"] = data["userId"];
        senderInfo["userColor"] = colors[m_lastUsedColors++ % colors.length()];
        m_clients[pSender] = senderInfo;
        //send back to channel clients the list of channel clients
        sendToChannel( channel, WS_ActionsType::clients, channelClients(channel) );
        break;
    //Actions not relevant for server
    case WS_ActionsType::clients:
    case WS_ActionsType::history:
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
        m_clients.remove(pClient);
        pClient->deleteLater();
        emit lstClientsChanged();
        if (m_clients.isEmpty())
            lastMessages.clear();
        //send back to channel clients the list of channel clients
        sendToChannel( channel, WS_ActionsType::clients, channelClients(channel) );

    }
}

void WSServer::sendToChannel(const QString& channel, WS_ActionsType action, const QJsonValue& data)
{
    //List of recipients
    QList<QWebSocket*> lstRecipients;
    for (QWebSocket* client : m_clients.keys())
    {
        if ( channel == m_clients[client]["channel"].toString() )
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

/////////////////////// CLIENT /////////////////////////////////////////////////

Networking::Networking(QObject *parent) : QObject(parent)
{
    m_pServer = new WSServer(parent);

}

Networking::~Networking()
{
    if ( clientRunning() )
        stopClient();
}

void Networking::startClient(const QUrl &url)
{
    if ( clientRunning() )
        stopClient();

    m_url = url;
    m_pWSClient = new QWebSocket();
    emit clientRunningChanged();

    connect( m_pWSClient, &QWebSocket::connected, this, &Networking::onConnected);
    connect( m_pWSClient, &QWebSocket::disconnected, this, &Networking::onDisconnected);
    connect( m_pWSClient, &QWebSocket::textMessageReceived, this, &Networking::onTextMessageReceived);
    connect( m_pWSClient, &QWebSocket::binaryMessageReceived, this, &Networking::onBinaryMessageReceived);
    connect( m_pWSClient, &QWebSocket::sslErrors, this, [=](){ qDebug()<< m_pWSClient->errorString();});
    connect( m_pWSClient, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error), this, [=](){ qDebug()<< m_pWSClient->errorString(); });

    m_pWSClient->open(QUrl(url));

    //save url as last used (we don't want to save local server url)
    if (!m_pServer)
        m_settings.setValue("lastWSConnectionUrl", url);

}

void Networking::stopClient()
{
    if ( !clientRunning() ) return;

    m_pWSClient->close();
    delete(m_pWSClient);//m_pWSClient->deleteLater() ;
    m_pWSClient = nullptr;
    emit clientRunningChanged();
}

QUrl Networking::lastWSConnectionUrl() const{
    return m_settings.value("lastWSConnectionUrl", "ws://swagsoftware.alwaysdata.net/:8100").toUrl();
}

void Networking::onLoginChanged(uint userId, const QString& userAlias)
{
    qDebug() << "now logged in as " <<  userAlias << " and id:" << userId;
    m_alias = userAlias;
    m_userId = userId;

    if (userId > 0)
        startClient( lastWSConnectionUrl()  );
    else stopClient();
    emit aliasChanged();
}

void Networking::sendActionToServer(Networking::WS_ActionsType action, const QJsonValue& data)
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

void Networking::sendMessage(const QString &message)
{
    if (!m_bIsConnected) return;

    QJsonObject obj;
    obj["message"] = message;


    sendActionToServer(WS_ActionsType::message, obj);

}

void Networking::modifyChannel(const QString &channelId, bool isPresenter)
{
    if (!m_bIsConnected) return;

    QJsonObject obj;
    obj["channel"] = channelId;
    obj["presenter"] = isPresenter;

    sendActionToServer(WS_ActionsType::channel, obj);

}

void Networking::onConnected()
{
    qDebug() << "WebSocket connected";
    qDebug() << "peerName:"<< m_pWSClient->peerName();
    qDebug() << "peerAddress:"<< m_pWSClient->peerAddress();
    qDebug() << "localAddress:"<< m_pWSClient->localAddress();
    qDebug() << "resourceName:"<< m_pWSClient->resourceName();
    qDebug() << "peerPort:"<< m_pWSClient->peerPort();
    qDebug() << "isValid:" << m_pWSClient->isValid();


    m_bIsConnected = true;
    emit connectedChanged();
    QJsonObject data;
    data["userName"]= m_alias;
    data["userId"]= static_cast<int>(m_userId);
    sendActionToServer(WS_ActionsType::hello, data);
    //sendTextMessage(data);

}

void Networking::onDisconnected()
{
    qDebug() << "WebSocket disconnected";
    m_bIsConnected = false;
    emit connectedChanged();

}

void Networking::onTextMessageReceived(QString message)
{
    qDebug() << "Message received:" << message;

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

void Networking::onBinaryMessageReceived(QByteArray message)
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

bool Networking::processMessage(Networking::WS_ActionsType action, const QJsonValue &data)
{
    switch(action)
    {
    case WS_ActionsType::history:
        m_lstMessage.clear();
        for (QJsonValue c : data.toArray() )
            m_lstMessage.append( c );
        emit receivedChatMessage( data );
        break;
    case WS_ActionsType::message:
        m_lstMessage.append( data );
        emit receivedChatMessage( data );
        break;
    case WS_ActionsType::clients:
        m_lstConnectedClients.clear();
        for (QJsonValue c : data.toArray() )
            m_lstConnectedClients.append(c);
        emit lstClientsChanged();
        break;
    default:
        qDebug() << "invalid actions:" << action << " with data:" << data;

    }
    return true;
}

