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

Frame {
    id: root

    Flickable {
        anchors.fill: parent
        anchors.margins: 10
        clip:true
        contentHeight: content.childrenRect.height

        Column{
            id:content
            anchors.fill: parent

            GroupBox{
                width: parent.width
                title: qsTr("username")
                TextField{
                    id:username
                    width: parent.width
                    text:pm.wp.userData["username"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("email")
                TextField{
                    id:email
                    width: parent.width
                    text:pm.wp.userData["email"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("registered")
                Label{
                    id:registered
                    width: parent.width
                    text:pm.wp.userData["registered"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("description")
                Label{
                    id:description
                    width: parent.width
                    text:pm.wp.userData["description"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("displayname")
                Label{
                    id:displayname
                    width: parent.width
                    text:pm.wp.userData["displayname"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("firstname")
                Label{
                    id:firstname
                    width: parent.width
                    text:pm.wp.userData["firstname"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("lastname")
                Label{
                    id:lastname
                    width: parent.width
                    text:pm.wp.userData["lastname"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("nicename")
                Label{
                    id:nicename
                    width: parent.width
                    text:pm.wp.userData["nicename"]
                }
            }
            GroupBox{
                width: parent.width
                title: qsTr("nickname")
                Label{
                    id:nickname
                    width: parent.width
                    text:pm.wp.userData["nickname"]
                }
            }

//            GroupBox{
//                Layout.fillWidth: true
//                title: qsTr("Danger area")
//                FAButton{
//                    color : "red"
//                    width: parent.width
//                    text:qsTr("Delete account - (warning : no way back !)")
//                    onClicked: pm.wp.deleteAccount();
//                }
//            }




        }

    }
}
