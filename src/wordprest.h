#ifndef WORDPREST_H
#define WORDPREST_H

#include <QObject>
#include <QSettings>
#include "restinpeace.h"

/**
 * @brief The Wordprest class
 *
 * This class handles communication with a wordpress site
 * Prerequisite : WP needs the following extensions : JSON API, JSON API USER, BUDYPRESS
 */
class Wordprest : public RestInPeace
{
    Q_OBJECT
    Q_PROPERTY( QVariantMap userData MEMBER m_userData NOTIFY loginChanged)
    Q_PROPERTY( uint userId MEMBER m_userId NOTIFY loginChanged)
    Q_PROPERTY( QString username MEMBER m_userName NOTIFY loginChanged)
    Q_PROPERTY( QString email MEMBER m_email NOTIFY loginChanged)
    Q_PROPERTY( QString avatar MEMBER m_avatar NOTIFY avatarChanged)
    Q_PROPERTY( bool loggedIn READ isLoggedIn NOTIFY loginChanged)

public:
    explicit Wordprest(QObject *parent = 0);

    bool isLoggedIn() const;

signals :
    void loginChanged();
    void avatarChanged();

public slots:
    bool logIn(const QString& username, const QString& password);
    bool logOut();
    bool signup(const QString& username, const QString& email, const QString& password);
    bool getAvatar(bool full = false);
    bool deleteAccount();
    bool passwordReset(const QString& username);

private:
    QVariantMap m_userData = QVariantMap{};
    uint m_userId = 0;
    QString m_userName = "";
    QString m_email = "";
    QString m_authCookie="";
    QSettings m_settings;
    QString m_avatar="";

};

#endif // WORDPREST_H
