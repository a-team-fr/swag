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
import MaterialIcons 1.0

Frame {
    id: root
    anchors.fill: parent
    anchors.margins: 5


        FAButton{
            width:parent.width/3
            height:parent.height
            icon : MaterialIcons.account_circle
            decorate: false
            Image{
                anchors.centerIn: parent
                width:parent.width / 2
                height:parent.height / 2
                visible : pm.wp.loggedIn && pm.wp.avatar
                fillMode: Image.PreserveAspectFit
                source : visible ? pm.wp.avatar : ""
            }

        }

        GroupBox{
            title:"Profile information"
            width:parent.width*2/3
            anchors.right : parent.right
            Column{
                width:parent.width
                FormItem{
                    width:parent.width
                    title: qsTr("username")
                    text:pm.wp.userData["username"]
                }
                FormItem{
                    width:parent.width
                    title: qsTr("email")
                    text:pm.wp.userData["email"]
                }
                FormItem{
                    width:parent.width
                    title: qsTr("registered")
                    text:pm.wp.userData["registered"]
                }

                FormItem{
                    width:parent.width
                    title: qsTr("displayname")
                    text:pm.wp.userData["displayname"]
                }
                FormItem{
                    width:parent.width
                    title: qsTr("firstname")
                    text:pm.wp.userData["firstname"]
                }
                FormItem{
                    width:parent.width
                    title: qsTr("lastname")
                    text:pm.wp.userData["lastname"]
                }
                FormItem{
                    width:parent.width
                    title: qsTr("nicename")
                    text:pm.wp.userData["nicename"]
                }
                FormItem{
                    width:parent.width
                    title: qsTr("nickname")
                    text:pm.wp.userData["nickname"]
                }
                FormItem{
                    width: parent.width
                    title: qsTr("description")
                    text:pm.wp.userData["description"]
                }

            }
        }








}
