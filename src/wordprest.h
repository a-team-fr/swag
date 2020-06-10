
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
    Q_PROPERTY( QVariantMap userData MEMBER m_userData NOTIFY userDataChanged)
    Q_PROPERTY( uint userId MEMBER m_userId NOTIFY loginChanged)
    Q_PROPERTY( QString username MEMBER m_userName NOTIFY loginChanged)
    Q_PROPERTY( QString email MEMBER m_email NOTIFY loginChanged)
    Q_PROPERTY( QString avatar READ avatar NOTIFY avatarChanged)
    Q_PROPERTY( bool loggedIn READ isLoggedIn NOTIFY loginChanged)

public:
    explicit Wordprest(QObject *parent = 0);

    bool isLoggedIn() const;

signals :
    void loginChanged();        //For some reason, I can't connect to this signal - workaround : on success login PrezManager::loginChanged is directly called
    void avatarChanged();
    void avatarsChanged();
    void userDataChanged();

public slots:
    bool logIn(const QString& username, const QString& password);
    bool logOut();
    bool signup(const QString& username, const QString& email, const QString& password);
    QString getAvatar(uint userID = 0, bool full = false);
    bool deleteAccount();
    bool passwordReset(const QString& username);
    //bool updateUser(const QVariantMap& valueMap);

    //bool emailexists(const QString& email);
    //bool usernameexists(const QString& email);

    //bool updatePassword(const QString& newPassword);
    //bool updateUserData(const QString& key, const QString& value);

private:
    QVariantMap m_userData = QVariantMap{};
    uint m_userId = 0;
    QString m_userName = "";
    QString m_email = "";
    QString m_authCookie="";
    QSettings m_settings;
    QString avatar() const;
    QMap<uint, QString> m_avatars;

    QString m_password; //TEMPO DEBUG


};

#endif // WORDPREST_H
