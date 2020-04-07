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
import QtQuick 2.0
import QtQuick.Controls 2.5
import fr.ateam.swag 1.0
import Swag 1.0
import FontAwesome 1.0

Popup{
    id:root
    property var target: null
    signal done();

    Column{
        height:parent.height
        width:parent.width
        TabBar{
            id:tabBar
            width:parent.width
            currentIndex:view.currentIndex
            onCurrentIndexChanged: view.currentIndex = currentIndex
            TabButton{
                text:qsTr("Base")
            }
            TabButton{
                text:target ? target.elementType : ""
            }
        }

        SwipeView {
            id: view
            visible: target
            height:parent.height-tabBar.contentHeight - footer.implicitHeight
            width:parent.width
            clip:true
            Item{
                ScrollView{
                clip:true
                anchors.fill: parent
                anchors.margins: 10
                Column{
                    width:parent.width
                    GroupBox{
                        title:qsTr("Id")
                        width:parent.width
                        TextField{
                            width:parent.width
                            text:(target && target.idAsAString) ? target.idAsAString : ""
                            onEditingFinished: {
                                //TODO : check unicity of id among slide elements
                                //TODO : enforce naming policy
                                target.idAsAString = text
                            }
                        }
                    }
                    GroupBox{
                        title:qsTr("z")
                        width:parent.width
                        TextField{
                            width:parent.width
                            text:target ? target.z : 0
                            onEditingFinished: target.z = Number(text)
                        }
                    }
                    GroupBox{
                        title:qsTr("rotation")
                        width:parent.width
                        TextField{
                            width:parent.width
                            text:target ? target.z : 0
                            onEditingFinished: target.z = Number(text)
                        }
                    }
                    GroupBox{
                        title:qsTr("navigationFocus")
                        width:parent.width
                        Switch{
                            checked: target ? target.navigationFocus : false
                            onToggled: target.navigationFocus = checked
                        }
                    }
                }
            }
            }
            Item{
                ScrollView{
                clip:true
                anchors.fill: parent
                anchors.margins: 10
                Loader{
                    anchors.fill: parent
                    sourceComponent: target ? target.editorComponent : null
                    property var target : root.target
                }
            }
            }

        }


        Button{
            id:footer
            text:qsTr("Ok")
            onClicked: root.done();
        }
    }


}
