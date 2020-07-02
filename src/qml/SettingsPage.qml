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
import MaterialIcons 1.0
import Swag 1.0

Frame{
    id:root

    CloseButton{}

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
        anchors.fill : parent
        anchors.margins: 10
        contentHeight: content.childrenRect.height + 50
        contentWidth: width
        clip:true

        Column{
            id:content
            width:parent.width
            spacing:15

            GroupBox{
                title: qsTr("Swag paths")
                width:parent.width
                Column{
                    width:parent.width
                    FormItem{
                        width:parent.width
                        title:qsTr("Install path")
                        readOnly: true
                        placeholderText: qsTr("install path is not defined")
                        placeholderTextColor: "red"
                        text:pm.installPath
                    }

                    FormItem{
                        width:parent.width
                        title:qsTr("Swag document path")
                        readOnly: true
                        placeholderText: qsTr("document path is not defined")
                        placeholderTextColor: "red"
                        text:pm.slideDecksFolderPath
                        showButton : true
                        onConfirmed: {
                            fileDialog.modifyInstallPath = false
                            fileDialog.folder = pm.slideDecksFolderPath
                            fileDialog.open()
                        }
                    }
                }
            }

            GroupBox{
                title: qsTr("Behavior at startup")
                width:parent.width
                Column{
                    width:parent.width
                    Switch{
                        text:qsTr("Open last document")
                        checked : NavMan.settings.openLastPrezAtStartup
                        onToggled: NavMan.settings.openLastPrezAtStartup = checked
                    }

                    Switch{
                        text:qsTr("enable Element3d")
                        checked : NavMan.settings.loadElement3d
                        onToggled: NavMan.settings.loadElement3d = checked
                    }
                }
            }

            GroupBox{
                title: qsTr("Network settings")
                width:parent.width
                Column{
                    width:parent.width
                    FormItem{
                        width:parent.width
                        title:qsTr("Backend host")
                        text:pm.wp.hostURI
                        onEditingFinished: {
                            pm.wp.hostURI = text
                            NavMan.settings.swagBackend = text
                        }
                    }
                    FormItem{
                        width:parent.width
                        title:qsTr("FTP host")
                        Component.onCompleted: text = NavMan.settings.ftpHost
                        onEditingFinished: NavMan.settings.ftpHost = text

                    }
                    FormItem{
                        width:parent.width
                        title:qsTr("FTP user")
                        Component.onCompleted: text = NavMan.settings.ftpUser
                        onEditingFinished: NavMan.settings.ftpUser = text

                    }
                    FormItem{
                        width:parent.width
                        title:qsTr("FTP password")
                        Component.onCompleted: text = NavMan.settings.ftpPassword
                        echoMode:TextInput.PasswordEchoOnEdit
                        onEditingFinished: NavMan.settings.ftpPassword = text

                    }
                    FormItem{
                        title:qsTr("FTP port number")
                        width:parent.width
                        Component.onCompleted: text = NavMan.settings.ftpPort
                        onEditingFinished: NavMan.settings.ftpPort = Number(text)

                    }
                    FormItem{
                        id:wsServerPort
                        width:parent.width
                        title:qsTr("local WebSocket server port")
                        placeholderText: qsTr("port number - leave empty for automatic selection")
                        readOnly : pm.net.localServer.serverRunning

                    }
                    Switch{
                        width:parent.width
                        text:checked ? qsTr("WebSocket server running (%1)").arg(pm.net.localServer.serverUrl) : qsTr("activate WebSocket server")
                        checked : pm.net.localServer.serverRunning
                        onToggled: pm.net.localServer.serverRunning ? pm.net.localServer.stopServer() : pm.net.localServer.startServer( wsServerPort.text.length > 0 ? Number(wsServerPort.text) : 0)
                    }
                    FormItem{
                        id:serverUrl
                        width:parent.width
                        title: qsTr("WebSocket server url")
                        placeholderText:qsTr("url of the WebSocket server")
                        readOnly : pm.net.clientRunning
                        text: pm.net.clientRunning ? pm.net.url : ( pm.net.localServer.serverRunning ? pm.net.localServer.serverUrl : pm.net.lastWSConnectionUrl )
                    }

                    Switch{
                        width:parent.width
                        text:pm.net.clientRunning ?qsTr("WebSocket connected with (%1)").arg(serverUrl.text) : qsTr("activate WebSocket")
                        checked : pm.net.clientRunning
                        ToolTip.text: qsTr("You need to be connected to a swag backend to use WebSocket")
                        ToolTip.visible: hovered && !pm.wp.loggedIn
                        onToggled: pm.net.clientRunning ? pm.net.stopClient() : pm.wp.loggedIn ? pm.net.startClient( serverUrl.text ) : null
                    }

                }
            }



            GroupBox{
                title: qsTr("Preferences")
                width:parent.width
                Column{
                    width:parent.width

                    FormItem{
                        title:qsTr("Default syntax highlighting style")
                        comboBox.model:["qtcreator_light", "qtcreator_dark"]
                        width:parent.width
                        Component.onCompleted : comboBox.currentIndex = comboBox.indexOfValue(NavMan.settings.defaultSyntaxHighlightingStyle)
                        onActivated: NavMan.settings.defaultSyntaxHighlightingStyle = comboBox.currentText

                    }


                    FormItem{
                        width: parent.width
                        title:qsTr("Theme name ")
                        extraContent:Component{Row{
                            spacing : 5
                            FAButton{
                                icon: MaterialIcons.brightness_4
                                ToolTip.text:qsTr("Dark mode")
                                ToolTip.visible: hovered
                                checked : NavMan.settings.materialTheme === Material.Dark
                                onClicked:NavMan.settings.materialTheme = Material.Dark
                            }
                            FAButton{
                                icon: MaterialIcons.brightness_5
                                ToolTip.text:qsTr("Light mode")
                                ToolTip.visible: hovered
                                checked : NavMan.settings.materialTheme === Material.Light
                                onClicked:NavMan.settings.materialTheme = Material.Light
                            }
                        }}
                    }

                    FormItem{
                        width: parent.width
                        title:qsTr("Theme primary color")
                        selectedColor: NavMan.settings.materialPrimary
                        showColorSelector: true
                        onColorPicked: NavMan.settings.materialPrimary = selectedColor
                        pickerParent : root
                    }
                    FormItem{
                        width: parent.width
                        title:qsTr("Theme accent")
                        selectedColor: NavMan.settings.materialAccent
                        showColorSelector: true
                        onColorPicked: NavMan.settings.materialAccent = selectedColor
                        pickerParent : root
                    }
                    FormItem{
                        width: parent.width
                        title:qsTr("Theme background color")
                        selectedColor: NavMan.settings.materialBackground
                        showColorSelector: true
                        onColorPicked: NavMan.settings.materialBackground = selectedColor
                        pickerParent : root
                    }
                    FormItem{
                        width: parent.width
                        title:qsTr("Theme foreground color")
                        selectedColor: NavMan.settings.materialForeground
                        showColorSelector: true
                        onColorPicked: NavMan.settings.materialForeground = selectedColor
                        pickerParent : root
                    }



                    FormItem{
                        title:qsTr("Theme elevation")
                        width:parent.width
                        text:NavMan.settings.materialElevation
                        onEditingFinished: NavMan.settings.materialElevation = text

                    }

                    RowLayout{
                        Layout.fillWidth: true
                        FormItem{
                            title:qsTr("Default page ratio")
                            Component.onCompleted: console.log("ratio reg : "+NavMan.settings.defaultPageRatio)
                            extraContent:Component{Row{
                                spacing : 5
                                FAButton{
                                    icon: MaterialIcons.crop_16_9
                                    ToolTip.text:qsTr("16/9 or 9/16")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio === 16/9 || NavMan.settings.defaultPageRatio === 9/16
                                    onClicked: NavMan.settings.defaultPageRatio = NavMan.settings.defaultPageRatio > 1 ? 16/9 : 9/16
                                }
                                FAButton{
                                    icon: MaterialIcons.crop_3_2
                                    ToolTip.text:qsTr("3/2 or 2/3")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio === 3/2 || NavMan.settings.defaultPageRatio === 2/3
                                    onClicked: NavMan.settings.defaultPageRatio = NavMan.settings.defaultPageRatio > 1 ? 3/2 : 2/3
                                }
                                FAButton{
                                    icon: MaterialIcons.crop_5_4
                                    ToolTip.text:qsTr("5/4 or 4/5")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio === 5/4 || NavMan.settings.defaultPageRatio === 4/5
                                    onClicked: NavMan.settings.defaultPageRatio = NavMan.settings.defaultPageRatio > 1 ? 5/4 : 4/5
                                }
                                FAButton{
                                    icon: MaterialIcons.crop_5_4
                                    ToolTip.text:qsTr("4/3 or 3/4")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio === 4/3 || NavMan.settings.defaultPageRatio === 3/4
                                    onClicked: NavMan.settings.defaultPageRatio = NavMan.settings.defaultPageRatio > 1 ? 4/3 : 3/4
                                }
                                FAButton{
                                    icon: MaterialIcons.crop_7_5
                                    ToolTip.text:qsTr("7/5 or 5/7")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio === 7/5 || NavMan.settings.defaultPageRatio === 5/7
                                    onClicked: NavMan.settings.defaultPageRatio = NavMan.settings.defaultPageRatio > 1 ? 7/5 : 5/7
                                }
                                FAButton{
                                    icon: MaterialIcons.crop_din
                                    ToolTip.text:qsTr("square")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio === 1
                                    onClicked:NavMan.settings.defaultPageRatio = 1
                                }
                            }}

                        }

                    }
                    RowLayout{
                        Layout.fillWidth: true
                        FormItem{
                            title:qsTr("Default page layout")

                            extraContent:Component{Row{
                                spacing : 5
                                FAButton{
                                    icon: MaterialIcons.landscape
                                    ToolTip.text:qsTr("Landscape")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio > 1
                                    onClicked: NavMan.settings.defaultPageRatio = 1/NavMan.settings.defaultPageRatio
                                }
                                FAButton{
                                    icon: MaterialIcons.portrait
                                    ToolTip.text:qsTr("Portrait")
                                    ToolTip.visible : hovered
                                    checked : NavMan.settings.defaultPageRatio <= 1
                                    onClicked: NavMan.settings.defaultPageRatio = 1/NavMan.settings.defaultPageRatio
                                }
                            }}

                        }

                    }
                }

            }


        }
    }


}
