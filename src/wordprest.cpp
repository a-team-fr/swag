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
#include "wordprest.h"
#include <QJsonValue>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>
#include <QUrlQuery>
#include <QDebug>

Wordprest::Wordprest(QObject *parent) : RestInPeace(parent)
{
    //Defines default headers
    setHostURI("https://swagsoftware.net/");
    //setExtraHostURI("");
    setRawHeader("Accept","application/json");

}

bool Wordprest::isLoggedIn() const
{
    return m_userId > 0;
}

bool Wordprest::logIn(const QString &username, const QString &password)
{
    if (!ready() || username.isEmpty() || password.isEmpty() ) return false;

    if (isLoggedIn())
        logOut();

    //Create nonce cookie
    setEndPoint("api/get_nonce/?controller=user&method=generate_auth_cookie");

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        if ( httpCode() == 200 ){
            QJsonObject obj = json.object();
            QString status = obj.value("status").toString();
            QString method = obj.value("method").toString();
            QString controller = obj.value("controller").toString();
            assert( ( status == "ok") && ( method == "generate_auth_cookie") && ( controller == "user"));
            QString nonce = obj.value("nonce").toString();

            setEndPoint("api/user/generate_auth_cookie/?nonce="+nonce+"&username="+username+"&password="+password);
            connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
                disconnect( qobject_cast<QNetworkReply*>(sender()) );
                if ( httpCode() == 200 ){
                    QJsonObject obj = json.object();
                    QString status = obj.value("status").toString();
                    QString cookie_name = obj.value("cookie_name").toString();
                    m_authCookie = obj.value("cookie").toString();
                    QJsonObject user = obj.value("user").toObject();
                    if (status == "error"){
                        setError( obj.value("error").toString() );
                    }
                    else
                    {
                        assert( ( status == "ok") );
                        m_userData = user.toVariantMap();
                        emit userDataChanged();
                        m_userName = user["username"].toString();
                        m_email = user["email"].toString();
                        m_userId = user["id"].toInt();
                        assert( m_userData["username"].toString() == username);
                        emit loginChanged();
                        //TODO validate nonce ?
                        m_settings.setValue("lastUserName", m_userName);
                        m_settings.setValue("lastPassword", password);

                        //For now on, use cookie in following request
                        setRawHeader("cookie",m_authCookie.toLatin1());

                        getAvatar();

                    }


                }

            } );
            request( RestInPeace::GET);
        }

    } );

    request( RestInPeace::GET);
    return true;
}

bool Wordprest::logOut()
{
    if (!isLoggedIn()) return false;

    m_userData = QVariantMap{};
    emit userDataChanged();
    m_userId = 0;
    m_userName = "";
    m_email = "";
    m_authCookie = "";
    emit loginChanged();
    m_avatar = "";
    emit avatarChanged();
    removeRawHeader("cookie");

    return true;
}

bool Wordprest::signup(const QString &username, const QString &email, const QString &password)
{
    if (!ready() || username.isEmpty() || password.isEmpty() ) return false;

    if (isLoggedIn())
        logOut();

    //Create nonce cookie
    setEndPoint("api/get_nonce/?controller=user&method=register");

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        if ( httpCode() == 200 ){
            QJsonObject obj = json.object();
            QString status = obj.value("status").toString();
            QString method = obj.value("method").toString();
            QString controller = obj.value("controller").toString();
            assert( ( status == "ok") && ( method == "register") && ( controller == "user"));
            QString nonce = obj.value("nonce").toString();

            setEndPoint( QString("api/user/register/?username=%1&email=%2&nonce=%3&user_pass=%4").arg(username, email, nonce, password));
            connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
                disconnect( qobject_cast<QNetworkReply*>(sender()) );
                if ( httpCode() == 200 ){
                    QJsonObject obj = json.object();
                    QString status = obj.value("status").toString();
                    QString cookie_name = obj.value("cookie_name").toString();
                    m_authCookie = obj.value("cookie").toString();
                    QJsonObject user = obj.value("user").toObject();
                    if (status == "error"){
                        setError( obj.value("error").toString() );
                    }
                    else
                    {
                        logIn(username, password);
                    }
                }

            } );
            request( RestInPeace::GET);
        }

    } );

    request( RestInPeace::GET);
    return true;


}

bool Wordprest::getAvatar(bool full)
{
    if (!isLoggedIn()) return false;

    setEndPoint(QString("api/user/get_avatar/?user_id=%1&type=%2").arg(m_userId).arg(full ? "full" : "thumb"));

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        if ( httpCode() == 200 ){
            QJsonObject obj = json.object();
            QString status = obj.value("status").toString();

            if ( status == "ok")
            {
                QString avatar = obj.value("avatar").toString();
                if (avatar.left(2) =="//")
                    m_avatar = "https://"+ avatar.right( avatar.length() - 2 ); //for some reason return avatar contains "//"
                else m_avatar = avatar;
                emit avatarChanged();
            }
            else
                setError( obj.value("error").toString());
        }
        else {
            setError( json.object().value("error").toString());
        }

    } );

    request( RestInPeace::GET);

    return true;
}

bool Wordprest::deleteAccount()
{
    if (!isLoggedIn()) return false;

    //Create nonce cookie
    setEndPoint("api/get_nonce/?controller=user&method=delete_account");

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        if ( httpCode() == 200 ){
            QJsonObject obj = json.object();
            QString status = obj.value("status").toString();
            if (status != "ok")
                return;

            QString nonce = obj.value("nonce").toString();

            setEndPoint( QString("api/user/delete_account/?nonce=%1&cookie=%2").arg(nonce, m_authCookie));
            connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
                disconnect( qobject_cast<QNetworkReply*>(sender()) );
                if ( httpCode() == 200 ){
                    QJsonObject obj = json.object();
                    QString status = obj.value("status").toString();
                    if (status == "error"){
                        setError( obj.value("error").toString() );
                    }
                    else
                    {
                        logOut();
                    }
                }

            } );
            request( RestInPeace::GET);
        }

    } );

    request( RestInPeace::GET);
    return true;
}

bool Wordprest::passwordReset(const QString& username)
{

    setEndPoint("api/user/retrieve_password/?user_login="+username);

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        if ( httpCode() == 200 ){
            QJsonObject obj = json.object();
            QString status = obj.value("status").toString();

            if ( status == "ok")
            {
                QString avatar = obj.value("avatar").toString();
                m_avatar = avatar.right( avatar.length() - 2 ); //for some reason return avatar contains "//"
            }
            else
                setError( obj.value("error").toString());
        }
        else {
            setError( json.object().value("error").toString());
        }

    } );

    request( RestInPeace::GET);

    return true;
}

/*
bool Wordprest::updateUser(const QVariantMap& valueMap)
{
    if (!isLoggedIn() || valueMap.isEmpty()) return false;
    if (valueMap.contains("user_email"))
    {
        //TODO check email is not already used

    }
    QStringList lstUserData;
    QStringList lstUserDataKeys = {"user_nicename","user_url", "user_email","user_pass", "display_name","nickname", "last_name"};
    QStringList lstUserMetaData;
    QVariantMap::const_iterator i = valueMap.constBegin();
    while (i != valueMap.constEnd()) {
        if ( !lstUserDataKeys.contains( i.key() ) )
             lstUserMetaData.append( i.key() + "=" + i.value().toString() );
        else lstUserData.append( i.key() + "=" + i.value().toString() );
        ++i;
    }
    if (!lstUserMetaData.isEmpty())
        lstUserData.append( QString("user_meta=[%1]").arg( lstUserMetaData.join(";") ) );

    setEndPoint( "api/user/update_user/?"+ lstUserData.join("&") );

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        QJsonObject obj = json.object();
        if ( httpCode() == 200 ){
            QString status = obj.value("status").toString();

            if ( status == "ok")
            {
                //update cached user data
                for (QVariantMap::const_iterator i = valueMap.constBegin(); i != valueMap.constEnd(); i++)
                    m_userData.insert(i.key(), i.value());
                emit userDataChanged();
            }
        }
        if ( obj.contains("error"))
            setError( obj.value("error").toString());
    } );

    request( RestInPeace::GET);

    return true;

}

bool Wordprest::emailexists(const QString &email)
{
    setEndPoint("api/user/email_exists/?email="+email);

    bool emailExists = true;
    connect(this, &RestInPeace::replyFinished, [=, &emailExists]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        QJsonObject obj = json.object();
        if ( obj.contains("error"))
            setError( obj.value("error").toString());

    } );

    request( RestInPeace::GET);

    return true;

    QEventLoop loop;
    connect(grabRes.data(), &QQuickItemGrabResult::ready, &loop, &QEventLoop::quit);
    loop.exec();
}

bool Wordprest::usernameexists(const QString &email)
{

}


bool Wordprest::updatePassword(const QString &newPassword)
{
    if (!isLoggedIn()) return false;
    setEndPoint("api/user/update_password/?password="+newPassword);

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        QJsonObject obj = json.object();
        if ( obj.contains("error"))
            setError( obj.value("error").toString());

    } );

    request( RestInPeace::GET);

    return true;

}

bool Wordprest::updateUserData(const QString &key, const QString &value)
{
    if (!isLoggedIn()) return false;
    setEndPoint( QString("api/user/update_user_meta/?meta_key=%1&meta_value=%2").arg(key, value) );

    connect(this, &RestInPeace::replyFinished, [=]( QJsonDocument json){
        disconnect( qobject_cast<QNetworkReply*>(sender()) );
        QJsonObject obj = json.object();
        if ( obj.contains("error"))
            setError( obj.value("error").toString());

    } );

    request( RestInPeace::GET);

    return true;

}
*/
