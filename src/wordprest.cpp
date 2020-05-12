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
            QString method = obj.value("method").toString();
            QString controller = obj.value("controller").toString();
            assert( ( status == "ok") && ( method == "delete_account") && ( controller == "user"));
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
