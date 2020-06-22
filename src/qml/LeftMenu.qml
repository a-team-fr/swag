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
import QtQuick 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
//import SortFilterProxyModel 0.2
import MaterialIcons 1.0
import FontAwesome 1.0
import fr.ateam.swag 1.0
import Swag 1.0

Drawer {
    id: root
    visible: true
    modal :false

    closePolicy: Popup.NoAutoClose

    signal newDocument();
    signal openDocument();

    component LeftMenuButton : FAButton{
        id:button
        width:parent.width
        height : width
        property alias toolTip : toolTip

        Rectangle{
            visible: button.checked
            width:2; height : button.height
            color : NavMan.settings.materialAccent//Material.Accent
        }

        ToolTip {
            id: toolTip
            visible : parent.hovered && text.length
            x: button.width + height /2 ; y: (button.height - height) / 2
            background: Rectangle{
                color:"grey"
                //TODO : use a canvas for tooltip arrow
                Rectangle{
                    color : parent.color
                    x:-width/2; y:width/2 ; rotation : 45
                    width : parent.height / 2 ; height : width
                }
            }

        }

        iconColor : Material.foreground//checked ? Material.accentColor : Material.foreground
        backgroundColor: "transparent"
    }


    Flickable{
        width: parent.width - 10
        height : parent.height - 10
        x:5;y:5
        contentHeight: content.childrenRect.height
        onHeightChanged: spacer.height = Math.max( 0, height - contentHeight)
        clip : true
        Column{
            id:content
            width:parent.width
            spacing : 5



            LeftMenuButton{
                icon: MaterialIcons.home
                toolTip.text:qsTr("Home")
                onClicked: { pm.unload(); pm.displayType = PM.Welcome}
                enabled : !pm.net.following
                //visible:pm.loaded
            }

            LeftMenuButton{
                icon: MaterialIcons.create_new_folder
                toolTip.text:qsTr("new document")
                onClicked: root.newDocument();
                visible : !pm.loaded
            }

            LeftMenuButton{
                icon: MaterialIcons.folder_open
                toolTip.text:qsTr("open")
                onClicked: root.openDocument()
                visible : !pm.loaded
            }

            ToolSeparator{ orientation: Qt.Horizontal;}

            Column{
                id:groupMode
                width: parent.width
                height:width * 3
                //spacing : 0
                visible : pm.loaded
                LeftMenuButton{
                    icon:MaterialIcons.edit
                    toolTip.text: qsTr("Edit mode")
                    onClicked: { pm.editMode = true ; pm.net.modifyChannel("0", false) }
                    checked: pm.editMode
                }
                LeftMenuButton{
                    icon: MaterialIcons.playlist_play
                    toolTip.text: qsTr("Preview")
                    onClicked: { pm.editMode = false ; pm.net.modifyChannel("0", false) }
                    checked: !pm.editMode && !pm.net.presenting
                }
                LeftMenuButton{
                    icon:MaterialIcons.play_arrow
                    toolTip.text: qsTr("Live presenting")
                    onClicked: { pm.editMode = false ;pm.net.modifyChannel(pm.net.me, true)}
                    checked : pm.net.presenting
                    enabled: pm.net.connected
                }
            }
            ToolSeparator{ orientation: Qt.Horizontal ; visible : pm.loaded}



            LeftMenuButton{
                icon: FontAwesome.mapSigns//checked ? MaterialIcons.close : FontAwesome.mapSigns
                useFontAwesome:true//checked ? false : true
                checked : pm.showNavigator
                toolTip.text: qsTr("Navigator")
                onClicked: pm.showNavigator = !pm.showNavigator
                visible: pm.loaded
            }
            LeftMenuButton{
                icon: MaterialIcons.settings//checked ? MaterialIcons.close : MaterialIcons.settings
                checked : pm.displayType === PM.PrezSettings
                toolTip.text:qsTr("Deck settings")
                onClicked: pm.displayType = ( pm.displayType === PM.PrezSettings ?  PM.Slide :PM.PrezSettings)
                enabled: !pm.net.following
                visible: pm.loaded
            }


            ToolSeparator{ orientation: Qt.Horizontal; visible: pm.loaded}

            LeftMenuButton{
                icon: MaterialIcons.file_upload
                toolTip.text:qsTr("Upload")
                onClicked: pm.unload()
                enabled:pm.loaded
                visible: pm.loaded
            }





            Item{ ///act as a spacer
                id:spacer
                width:1
            }

            ToolSeparator{ orientation: Qt.Horizontal}

            LeftMenuButton{
                icon: MaterialIcons.question_answer//checked ? MaterialIcons.close : MaterialIcons.question_answer
                checked: pm.displayType === PM.NetworkingTest
                toolTip.text:qsTr("chat")
                onClicked: pm.displayType = ( pm.displayType === PM.NetworkingTest ?  (pm.loaded ? PM.Slide : PM.Welcome) :PM.NetworkingTest)
                enabled:pm.net
            }

            LeftMenuButton{
                icon: MaterialIcons.settings_applications//checked ? MaterialIcons.close : MaterialIcons.settings_applications
                checked: pm.displayType === PM.GlobalSettings
                toolTip.text:qsTr("Swag settings")
                onClicked: pm.displayType = ( checked ?  (pm.loaded ? PM.Slide : PM.Welcome) :PM.GlobalSettings)
            }

            LeftMenuButton{
                onClicked: pm.wp.loggedIn ? pm.wp.logOut() : pm.displayType = PM.WPConnect
                toolTip.text:pm.wp.loggedIn ? qsTr("Sign out") : qsTr("Sign in / register")
                icon: pm.wp.loggedIn ? FontAwesome.signOutAlt : FontAwesome.signInAlt
                useFontAwesome: true

            }
            LeftMenuButton{
                icon: MaterialIcons.account_circle//checked ? MaterialIcons.close : MaterialIcons.account_circle
                checked: pm.displayType === PM.WPProfile
                toolTip.text:qsTr("show profile (%1)").arg(pm.wp.username)
                onClicked: pm.displayType = ( checked ?  (pm.loaded ? PM.Slide : PM.Welcome) :PM.WPProfile)
                enabled : pm.wp.loggedIn
            }



        }

    }

}
