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
import QtQuick 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0
import Swag 1.0
import FontAwesome 1.0
import Qt.labs.settings 1.0

Pane {
    id: root
    property alias register : registerSel.checked

    Connections{
        target:pm.wp
        onLoginChanged: {
            if (pm.wp.loggedIn)
                pm.displayType = pm.loaded ? PM.Slide : PM.Welcome
        }

    }

    Settings{
        id:settings
        property string lastUserName : ""
        property string lastPassword : ""
    }

    ColumnLayout{
        anchors.fill: parent


        TextField{
            id:username
            Layout.fillWidth: true
            text:settings.lastUserName
            placeholderText: qsTr("fill in here your username")
        }
        TextField{
            id:email
            Layout.fillWidth: true
            placeholderText: qsTr("fill in here your contact email")
        }
        TextField{
            id:password
            Layout.fillWidth: true
            text:settings.lastPassword
            placeholderText: qsTr("fill in here your password")
            echoMode: TextInput.Password
            passwordMaskDelay: 1000
        }
        TextField{
            id:password2
            visible : root.register
            Layout.fillWidth: true
            placeholderText: qsTr("confirm password")
            ToolTip.visible : hovered && password.text !== password2.text
            ToolTip.text : qsTr("password are not identical")
            echoMode: TextInput.Password
            passwordMaskDelay: 1000
        }
        Switch{
            id:registerSel
            text:qsTr("Register")
            checked: root.register
        }
        FAButton{
            decorate : false
            visible: !root.register
            color :"blue"
            text:qsTr("Reset password")
            enabled:username.text.length > 0
            onClicked: pm.wp.passwordReset(username.text)
        }

        Label{
            id:error
            visible:text.length > 0
            color : "red"
            text:pm.wp.error
        }
        FAButton{
            text: root.register ? qsTr("Register") : qsTr("Log in")
            enabled : root.register ? username.text && email.text && password.text && password2.text === password.text: username.text && password.text
            onClicked: root.register ? pm.wp.signup(username.text, email.text, password.text) : pm.wp.logIn( username.text, password.text)
        }
        Label{
            visible : pm.wp.loggedIn
            text:qsTr("Connected as %1").arg(pm.wp.username)
        }
    }
}
