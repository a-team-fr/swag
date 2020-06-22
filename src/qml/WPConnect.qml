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
import Qt.labs.settings 1.0
import FontAwesome 1.0
import MaterialIcons 1.0

Pane {
    id: root
    readonly property bool register : bar.currentIndex === 1

    Connections{
        target:pm.wp

        function onLoginChanged(){
            if (pm.wp.loggedIn)
                pm.displayType = pm.loaded ? PM.Slide : PM.Welcome
        }
    }

    Settings{
        id:settings
        property string lastUserName : ""
        property string lastPassword : ""
    }

    Frame{
        width : Math.min(parent.width, 400)
        height : Math.min(parent.height, 350)
        anchors.centerIn: parent

        TabBar{
            id:bar
            width : parent.width
            TabButton {
                text: qsTr("Sign in")
            }
            TabButton {
                text: qsTr("Register")
            }
        }

        ColumnLayout{
            anchors.fill: parent
            anchors.topMargin: bar.height


            FormItem{
                id:username
                title:qsTr("User name")
                Layout.fillWidth: true
                text:NavMan.settings.signinAtStartup ? settings.lastUserName : ""
                placeholderText: qsTr("fill in here your username")
            }
            FormItem{
                id:email
                title:qsTr("Email")
                Layout.fillWidth: true
                visible : root.register
                placeholderText: qsTr("fill in here your contact email")
            }
            RowLayout{
                Layout.fillWidth: true
                FormItem{
                    id:password
                    title:qsTr("Password")
                    Layout.fillWidth: true
                    text:NavMan.settings.signinAtStartup ? settings.lastPassword : ""
                    placeholderText: qsTr("fill in here your password")
                    echoMode: passwordVisibility.checked ? TextInput.Password : TextInput.Normal
                }
                FAButton{
                    id:passwordVisibility
                    checked:true
                    decorate:false
                    icon : checked ? MaterialIcons.visibility : MaterialIcons.visibility_off
                    onClicked: checked = !checked
                }
            }

            FormItem{
                id:password2
                title:qsTr("Confirm password")
                visible : root.register
                Layout.fillWidth: true
                placeholderText: qsTr("confirm password")
                ToolTip.visible : hovered && password.text !== password2.text
                ToolTip.text : qsTr("password are not identical")
                echoMode: TextInput.Password
            }

            Switch{
                text:qsTr("Remember me")
                visible : !root.register
                checked : NavMan.settings.signinAtStartup
                onToggled: NavMan.settings.signinAtStartup = checked
            }



            Label{
                id:error
                visible:text.length > 0
                color : "red"
                text:pm.wp.error
            }
            Label{
                visible:!pm.wp.sslSupported
                color : "red"
                text:qsTr("OpenSSL v.%1 is required (installed version is %2)").arg(pm.wp.sslLibraryBuildVersionString).arg(pm.wp.sslLibraryVersionString)
            }
            FAButton{
                Layout.alignment: Qt.AlignRight
                decorate : false
                visible: !root.register
                color :"lightblue"
                text:qsTr("Reset password")
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Send a reset link to the registered email")
                enabled:username.text.length > 0
                onClicked: pm.wp.passwordReset(username.text)
            }
            FAButton{
                Layout.alignment: Qt.AlignHCenter
                icon: root.register ? FontAwesome.userPlus : FontAwesome.signInAlt
                useFontAwesome: true
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
}
