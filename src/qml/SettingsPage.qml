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
import QtQuick.Layouts 1.2
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import fr.ateam.swag 1.0
import QtQuick.Controls.Material 2.14
import Swag 1.0
import FontAwesome 1.0

Frame{
    id:root


    FileDialog{
        id: fileDialog
        property bool modifyInstallPath : true
        selectFolder: true
        onAccepted: {
            if (true)  pm.installPath = fileUrl
            else pm.slideDecksFolderPath = fileUrl
        }
    }

    Flickable {
        contentHeight: content.childrenRect.height + 50
        anchors.fill : parent
        anchors.margins: 10
        clip:true

        Column{
            id:content
            width:parent.width
            spacing:5

            GroupBox{
                title: qsTr("Swag install path")
                width:parent.width

                RowLayout{
                    width:parent.width
                    TextField{
                        text:pm.installPath
                        Layout.fillWidth: true
                        readOnly: true
                        placeholderText: qsTr("install path is not defined")
                        placeholderTextColor: "red"
                    }
//                    Button{
//                        text:"..."
//                        onClicked:  {
//                            fileDialog.modifyInstallPath = true
//                            fileDialog.folder = pm.installPath
//                            fileDialog.open()
//                        }
//                    }
                }
            }
            GroupBox{
                title: qsTr("Swag document path")
                width:parent.width

                RowLayout{
                    width:parent.width
                    TextField{
                        text:pm.slideDecksFolderPath
                        Layout.fillWidth: true
                        readOnly: true
                        placeholderText: qsTr("document path is not defined")
                        placeholderTextColor: "red"
                    }
                    Button{
                        text:"..."
                        onClicked: {
                            fileDialog.modifyInstallPath = false
                            fileDialog.folder = pm.slideDecksFolderPath
                            fileDialog.open()
                        }
                    }
                }
            }

            Switch{
                text:qsTr("Open last document at startup")
                checked : NavMan.settings.openLastPrezAtStartup
                onToggled: NavMan.settings.openLastPrezAtStartup = checked
            }
            Switch{
                text:qsTr("enable Element3d")
                checked : NavMan.settings.loadElement3d
                onToggled: NavMan.settings.loadElement3d = checked
            }

            GroupBox{
                title: qsTr("Default syntax highlighting style")
                width:parent.width

                ComboBox{
                    model:["qtcreator_light", "qtcreator_dark"]
                    width:parent.width
                    displayText: NavMan.settings.defaultSyntaxHighlightingStyle
                    onCurrentTextChanged: NavMan.settings.defaultSyntaxHighlightingStyle = currentText
                }
            }

            GroupBox{
                title:qsTr("Profile")
                Layout.fillWidth: true
                TextField{
                    width:parent.width
                    placeholderText: "Please fill in your profile identifier"
                    text:NavMan.settings.profileAuthor
                    onEditingFinished: NavMan.settings.profileAuthor = text
                }
            }

            ListModel{
                id:lstMaterialColor
                ListElement{ v:"#ffffff"; l:"White"}
                ListElement{ v:"#303030"; l:"background(dark)"}
                ListElement{ v:"#CFCFCF"; l:"background(light)"}
                ListElement{ v:"#000000"; l:"Black"}


                ListElement{ v:"#EF9A9A"; l:"Red (dark)"}
                ListElement{ v:"#F48FB1"; l:"Pink (dark)"}
                ListElement{ v:"#CE93D8"; l:"Purple (dark)"}
                ListElement{ v:"#B39DDB"; l:"DeepPurple (dark)"}
                ListElement{ v:"#9FA8DA"; l:"Indigo (dark)"}
                ListElement{ v:"#90CAF9"; l:"Blue (dark)"}
                ListElement{ v:"#81D4FA"; l:"LightBlue (dark)"}
                ListElement{ v:"#80DEEA"; l:"Cyan (dark)"}
                ListElement{ v:"#80CBC4"; l:"Teal (dark)"}
                ListElement{ v:"#A5D6A7"; l:"Green (dark)"}
                ListElement{ v:"#C5E1A5"; l:"LightGreen (dark)"}
                ListElement{ v:"#E6EE9C"; l:"Lime (dark)"}
                ListElement{ v:"#FFF59D"; l:"Yellow (dark)"}
                ListElement{ v:"#FFE082"; l:"Amber (dark)"}
                ListElement{ v:"#FFCC80"; l:"Orange (dark)"}
                ListElement{ v:"#FFAB91"; l:"DeepOrange (dark)"}
                ListElement{ v:"#BCAAA4"; l:"Brown (dark)"}
                ListElement{ v:"#EEEEEE"; l:"Grey (dark)"}
                ListElement{ v:"#B0BEC5"; l:"BlueGrey (dark)"}

                ListElement{ v:"#F44336"; l:"Red (light)"}
                ListElement{ v:"#E91E63"; l:"Pink (light)"}
                ListElement{ v:"#9C27B0"; l:"Purple (light)"}
                ListElement{ v:"#673AB7"; l:"DeepPurple (light)"}
                ListElement{ v:"#3F51B5"; l:"Indigo (light)"}
                ListElement{ v:"#2196F3"; l:"Blue (light)"}
                ListElement{ v:"#03A9F4"; l:"LightBlue (light)"}
                ListElement{ v:"#00BCD4"; l:"Cyan (light)"}
                ListElement{ v:"#009688"; l:"Teal (light)"}
                ListElement{ v:"#4CAF50"; l:"Green (light)"}
                ListElement{ v:"#8BC34A"; l:"LightGreen (light)"}
                ListElement{ v:"#CDDC39"; l:"Lime (light)"}
                ListElement{ v:"#FFEB3B"; l:"Yellow (light)"}
                ListElement{ v:"#FFC107"; l:"Amber (light)"}
                ListElement{ v:"#FF9800"; l:"Orange (light)"}
                ListElement{ v:"#FF5722"; l:"DeepOrange (light)"}
                ListElement{ v:"#795548"; l:"Brown (light)"}
                ListElement{ v:"#9E9E9E"; l:"Grey (light)"}
                ListElement{ v:"#607D8B"; l:"BlueGrey (light)"}
            }
            GroupBox{
                title:qsTr("Theme")
                Layout.fillWidth: true
                Flow{
                    spacing : 10
                    width:parent.width
                    GroupBox{
                        title:qsTr("Name")
                        ComboBox{
                            width:parent.width
                            model: [{v:Material.Light, l:"Light"}, {v:Material.Dark, l:"Dark"}]
                            textRole: "l";valueRole: "v"
                            onActivated: NavMan.settings.materialTheme = currentValue
                            Component.onCompleted: currentIndex = indexOfValue(NavMan.settings.materialTheme)
                        }
                    }

                    GroupBox{
                        title:qsTr("Accent")
                        ComboBox{
                            width:parent.width
                            model: lstMaterialColor
                            textRole: "l";valueRole: "v"
                            onActivated: NavMan.settings.materialAccent = currentValue
                            Component.onCompleted: currentIndex = indexOfValue(NavMan.settings.materialAccent)
                        }
                    }
                    GroupBox{
                        title:qsTr("Background")
                        ComboBox{
                            width:parent.width
                            model: lstMaterialColor
                            textRole: "l";valueRole: "v"
                            onActivated: NavMan.settings.materialBackground = currentValue
                            Component.onCompleted: currentIndex = indexOfValue(NavMan.settings.materialBackground)
                        }
                    }
                    GroupBox{
                        title:qsTr("Elevation")
                        TextField{
                            width:parent.width
                            text:NavMan.settings.materialElevation
                            onEditingFinished: NavMan.settings.materialElevation = text
                        }
                    }
                    GroupBox{
                        title:qsTr("Foreground")
                        ComboBox{
                            width:parent.width
                            model: lstMaterialColor
                            textRole: "l";valueRole: "v"
                            onActivated: NavMan.settings.materialForeground = currentValue
                            Component.onCompleted: currentIndex = indexOfValue(NavMan.settings.materialForeground)
                        }
                    }
                    GroupBox{
                        title:qsTr("Primary")
                        ComboBox{
                            width:parent.width
                            model: lstMaterialColor
                            textRole: "l";valueRole: "v"
                            onActivated: NavMan.settings.materialPrimary = currentValue
                            Component.onCompleted: currentIndex = indexOfValue(NavMan.settings.materialPrimary)
                        }
                    }
                }
            }






        }
    }


}
