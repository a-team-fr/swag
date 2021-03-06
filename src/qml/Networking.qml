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
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0
import Swag 1.0
import MaterialIcons 1.0

Frame {
    id: root

//    property var lstTestMessageJSArray : [
//        {text: "hello", time : 147559985, userName:"test", userColor:"red", userId:1},
//        {text: "coucou", time : new Date(), userName:"test2", userColor:"red", userId:2}
//    ]

    CloseButton{}

    ColumnLayout{
        id:content
        anchors.fill: parent
        Label{
            text:qsTr("Currently in channel : %1").arg( pm.net.channel === "0" ? "general" : pm.net.channel)
            Layout.fillWidth: true
        }

        SplitView{
            width:parent.width
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip:true
            ListView{
                id:lstMessage
                SplitView.preferredWidth: parent.width * 3 / 4
                SplitView.fillHeight: true
                model:pm.net.lstMessage
                spacing: 1
                clip:true

                function isPreviousSameAuthor(theindex){
                    if (theindex === 0) return false;
                    var prev = pm.net.lstMessage[theindex-1].userName;
                    var cur = pm.net.lstMessage[theindex].userName;
                    return prev === cur;
                }

                delegate: ItemDelegate{
                    height:delegate.height
                    RowLayout{
                        id:delegate

                        Image{
                            height:visible ? parent.height : 0
                            width:height
                            visible : !lstMessage.isPreviousSameAuthor(index)
                            fillMode: Image.PreserveAspectFit
                            //source : pm.wp.getAvatar( Number(modelData.userId) )
                            source : pm.wp.getAvatar( Number(modelData.userId) )
                        }

                        ColumnLayout{
                            Layout.fillWidth:true
                            RowLayout{
                                width:parent.width
                                visible : !lstMessage.isPreviousSameAuthor(index)
                                Label{
                                    Layout.preferredWidth: 100
                                    color:modelData.userColor
                                    text:modelData.userName
                                }
                                Label{
                                    Layout.fillWidth:true
                                    color:"grey"
                                    elide:Text.ElideRight
                                    text:( new Date(modelData.time) ).toLocaleTimeString()
                                }

                            }

                            Label{
                                Layout.fillHeight: true
                                width:parent.width
                                text:modelData.text
                            }
                        }


                    }
                }


            }

            ListView{
                SplitView.preferredWidth: parent.width / 4
                SplitView.fillHeight: true
                model:pm.net.lstConnectedClients
                header:Label{ text:qsTr("Currently connected :")}
                headerPositioning:ListView.OverlayHeader
                clip:true
                spacing: 10
                delegate: ItemDelegate{
                    width:parent.width
                    RowLayout{
                        anchors.fill: parent
                        Image{
                            height:parent.height
                            width:height
                            fillMode: Image.PreserveAspectFit
                            source : pm.wp.getAvatar( Number(modelData.userId) )
                        }

                        Label{
                            Layout.fillWidth: true
                            color:modelData.userColor
                            text: modelData.userName
                        }
                    }

                }
            }

        }
        RowLayout{
            width:parent.width
            TextField{
                id:txtMessage
                focus: true
                Layout.fillWidth: true
                placeholderText:qsTr("Type here the message you want to send to others connected swag")
                onAccepted: pm.net.sendMessage(txtMessage.text)
            }
            FAButton{
              enabled: txtMessage.text && pm.net.connected
              onClicked: pm.net.sendMessage(txtMessage.text)
              ToolTip.visible:hovered
              ToolTip.text : qsTr("Send message")
              icon: MaterialIcons.send
            }
        }





    }


    Popup{
        modal:true
        anchors.centerIn: parent
        //width:root.width * 0.8
        //height : root.height * 0.8
        visible: !pm.net.clientRunning
        closePolicy: Popup.NoAutoClose
        ColumnLayout{
            Label{
                color:"red"
                text:qsTr("This feature needs WS client to be running")
            }
            Button{
                Layout.alignment: Qt.AlignHCenter
                text:qsTr("go to settings")
                onClicked: pm.displayType = PM.GlobalSettings
            }
        }
    }

}
