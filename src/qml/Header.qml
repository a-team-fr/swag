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
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import FontAwesome 1.0
import fr.ateam.swag 1.0
import Swag 1.0

ToolBar{
        id:toolbar
        signal toggleMenu();
        Row{
            anchors.fill: parent
            anchors.margins:5
            spacing: 5

            FAButton{
                icon:FontAwesome.alignJustify
                height:parent.height
                width:height
                visible: pm.loaded
                onClicked: toolbar.toggleMenu()
                decorate: false
            }

            Label{
                width : parent.width - height - closeButton.width - loginAlias.width - 2*parent.spacing
                height:parent.height
                visible:!pm.editMode
                minimumPointSize:5
                fontSizeMode:Text.Fit
                font.pointSize : 50
                text: pm.title
            }
            TextField{
                width : parent.width - height - closeButton.width - loginAlias.width - 2*parent.spacing
                height:parent.height
                visible:pm.editMode
                text: pm.title
                onEditingFinished: pm.saveSlideSettings("title", text)
            }
            FAButton{
                id:loginAlias
                height:parent.height
                width:height
                icon: pm.wp.loggedIn ? FontAwesome.signOut : FontAwesome.signIn
                onClicked: pm.wp.loggedIn ? pm.wp.logOut() : pm.displayType = PM.WPConnect
                //ToolTip.text : pm.wp.loggedIn ? qsTr("Sign out") : qsTr("Sign in / register")
                //ToolTip.visible: hovered
                onHoveredChanged: { if (hovered) wpmenu.open()}
                Image{
                    anchors.fill: parent
                    visible : pm.wp.loggedIn && pm.wp.avatar
                    fillMode: Image.PreserveAspectFit
                    source : visible ? pm.wp.avatar : ""
                    //onSourceChanged: console.log(source)
                }
                Menu{
                    id:wpmenu
                    x : toolbar.width - width
                    y : parent.height


                    Label{
                        visible : pm.wp.loggedIn
                        text:qsTr("currently log as %1").arg(pm.wp.username)
                    }

                    MenuItem{
                        text:pm.wp.loggedIn ? qsTr("Sign out") : qsTr("Sign in / register")
                        onClicked: pm.wp.loggedIn ? pm.wp.logOut() : pm.displayType = PM.WPConnect
                    }
                    MenuItem{
                        enabled: pm.wp.loggedIn
                        text:qsTr("show profile");
                        onClicked: pm.displayType = PM.WPProfile
                    }

                }
            }

            FAButton{
                id:closeButton
                decorate:false
                icon:FontAwesome.close
                height:parent.height
                width:visible ? height:0
                visible : pm.displayType != PM.Welcome && (!pm.loaded || !pm.isSlideDisplayed)
                onClicked: pm.displayType = pm.loaded ? PM.Slide : PM.Welcome //close()
            }
        }


    }
