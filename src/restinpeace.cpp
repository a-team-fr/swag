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
#include "restinpeace.h"

/*!
    \class RestInPeace


*/

/* -------------------- Constructor and destructor ----------------------------------*/
RestInPeace::RestInPeace(QObject *parent) :
    QObject(parent)
{
    m_pNAM = new QNetworkAccessManager(this);

}
    
RestInPeace::~RestInPeace()
{

}



/* -------------------- Property accessors ----------------------------------*/
void RestInPeace::setHostURI(const QString& res){
    m_hostURI = res;
    emit hostChanged();
    emit readyChanged();

}
QString RestInPeace::hostURI() const{
    return m_hostURI;
}
void RestInPeace::setError(const QString& res){
    m_error = res;
    emit errorChanged();
}
QString RestInPeace::error() const{
    return m_error;
}
void RestInPeace::setEndPoint(const QString& res){
    m_endPoint = res;
    emit endPointChanged();

}
QString RestInPeace::endPoint() const{
    return m_endPoint;
}
void RestInPeace::setPercComplete(qreal res){
    m_percComplete = res;
    emit percCompleteChanged();
}
qreal RestInPeace::percComplete() const{
    return m_percComplete;
}
void RestInPeace::setHttpResponse(const QString& res){
    m_httpResponse = res;
    emit httpResponseChanged();
}
QString RestInPeace::httpResponse() const{
    return m_httpResponse;
}
void RestInPeace::setHttpCode(uint res){
    m_httpCode = res;
    emit httpCodeChanged();
}
uint RestInPeace::httpCode() const{
    return m_httpCode;
}

bool RestInPeace::ready() const
{
    return !hostURI().isEmpty() && percComplete()==100;
}


/* -------------------- Slots ----------------------------------*/



void RestInPeace::readReply( QNetworkReply *reply )
{
    setPercComplete(100);
    setHttpCode( reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt() );
    //QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    Q_ASSERT( reply);
    //httpResponse = QString(reply->readAll());
    QJsonDocument json;
    m_lastRequestSuccessful = false;
    if (reply)
    {
        QUrl redirectUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
        if (!redirectUrl.isEmpty())
        {
            reply->deleteLater();
            //open(redirectUrl);
            return;
        }
        else if (reply->error() == QNetworkReply::NoError)
        {
            m_lastRequestSuccessful = true;
            json = QJsonDocument::fromJson( reply->readAll() );
            setError("");
        }
        reply->deleteLater();
    }
    qInfo() << "REPLYFINISHED" << json;
    emit replyFinished(json);
}


void RestInPeace::replyError(QNetworkReply::NetworkError)
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    Q_ASSERT( reply);
    setHttpCode( reply->error() );
    setError(reply->errorString());
    qDebug() << "REPLY ERROR" << reply->errorString();

}

void RestInPeace::replyProgress(qint64 bytesSent, qint64 bytesTotal)
{
    setPercComplete( (bytesTotal!=0) ? bytesSent/bytesTotal*100 : 100);
}


QNetworkReply* RestInPeace::request( RestInPeace::Operation operation, QUrl url , QJsonDocument data)
{
    QNetworkRequest request;
    request.setUrl( url);

    //Define headers
    for (auto k : m_rawHeader.keys()){
        //qDebug() << k << ":" << rawHeader.value( k );
        request.setRawHeader(k, m_rawHeader.value( k ));
    }
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    //Proceed with request
    QNetworkReply *reply;
    switch (operation)
    {
    case GET:
        reply = m_pNAM->get(request);
        break;
    case POST:
        reply = m_pNAM->post(request, data.toJson());
        break;
    case PUT:
        reply = m_pNAM->put(request, data.toJson());
        break;
    case DELETE:
        reply = m_pNAM->deleteResource(request);
        break;
    }
    return reply;

}

QNetworkReply* RestInPeace::request( RestInPeace::Operation operation, QJsonDocument data )
{
    setPercComplete(0);

    QString qsUrl = m_hostURI;
    qsUrl += m_extraHostURI.isEmpty() ? "" : "/" + m_extraHostURI;
    qsUrl += m_endPoint.isEmpty() ? "" : "/" + m_endPoint;

    qDebug() << "Start request - " << operation << "- url:" << qsUrl;
    QNetworkReply *reply = request(operation, QUrl( qsUrl), data );


    connect(reply, &QNetworkReply::finished, [=](){ this->readReply(reply);} );
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(replyError(QNetworkReply::NetworkError)));
    //connect(reply, SIGNAL(sslErrors(QList<QSslError>)), this, SLOT(slotSslErrors(QList<QSslError>)));
    connect(reply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(replyProgress(qint64, qint64)));
    connect(reply, SIGNAL(uploadProgress(qint64,qint64)), this, SLOT(replyProgress(qint64, qint64)));

    return reply;
}
