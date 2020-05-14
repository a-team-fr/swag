#ifndef RESTINPEACE_H
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
#define RESTINPEACE_H
#include <QObject>

#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>
#include <QJsonDocument>


class RestInPeace : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString hostURI READ hostURI  WRITE setHostURI NOTIFY hostChanged)
    Q_PROPERTY( QString endPoint READ endPoint WRITE setEndPoint NOTIFY endPointChanged)
    Q_PROPERTY( QString error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY( qreal percComplete READ percComplete WRITE setPercComplete NOTIFY percCompleteChanged)
    Q_PROPERTY( uint httpCode READ httpCode WRITE setHttpCode NOTIFY httpCodeChanged)
    Q_PROPERTY( QString httpResponse READ httpResponse WRITE setHttpResponse NOTIFY httpResponseChanged)
    Q_PROPERTY( bool ready READ ready NOTIFY readyChanged)


public:

    explicit RestInPeace(QObject *parent = 0);
    virtual ~RestInPeace();

    enum Operation{ GET, POST, PUT, DELETE};

public: // property access
    QString hostURI() const;
    void setHostURI(const QString& res);
    QString error() const;
    QString endPoint() const;
    void setEndPoint(const QString& res);
    qreal percComplete() const;
    QString httpResponse() const;
    uint httpCode() const;
    virtual bool ready() const;

private slots: // common network operations
    void readReply( QNetworkReply *reply );
    void replyError(QNetworkReply::NetworkError);
    void replyProgress(qint64 bytesSent, qint64 bytesTotal);


protected:

    QNetworkReply* request( RestInPeace::Operation operation, QJsonDocument data = QJsonDocument());

    void setError(const QString& res);
    void setPercComplete(qreal res);
    void setHttpResponse(const QString& res);
    void setHttpCode(uint res);

    //Use this to manage headers
    void setRawHeader(QByteArray name, QByteArray value){ m_rawHeader[name] = value;}
    void removeRawHeader(QByteArray name){ m_rawHeader.remove(name);}
    void resetRawHeader(){ m_rawHeader.empty();}

    void setExtraHostURI(QString res){ m_extraHostURI = res;}
    bool isLastRequestSuccessful()const{ return m_lastRequestSuccessful;}


signals: // operation notifications
    void hostChanged();
    void endPointChanged();
    void errorChanged();
    void percCompleteChanged();
    void httpCodeChanged();
    void httpResponseChanged();
    void replyFinished( QJsonDocument);                                                 ///emited when a request gets replied
    void queryFailed(QJsonDocument );
    void querySucceeded(QHash<int, QByteArray> roles, QVector<QVariantMap> data);
    void readyChanged();

private:
    QNetworkReply* request( RestInPeace::Operation operation, QUrl url, QJsonDocument data = QJsonDocument()  );
    QNetworkAccessManager *m_pNAM = nullptr;
    QMap<QByteArray, QByteArray> m_rawHeader;
    QString m_hostURI = "";
    QString m_extraHostURI = "";
    QString m_endPoint = "";
    QString m_error = "";
    qreal m_percComplete = 100.;
    bool m_lastRequestSuccessful = false;

    uint m_httpCode = 0;
    QString m_httpResponse = "";
};

#endif // RESTINPEACE_H

