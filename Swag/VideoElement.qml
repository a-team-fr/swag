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
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0
import QtMultimedia 5.14
import FontAwesome 1.0

Element {
    id: root

    property bool useCamera : false
    property bool showPanel : true
    property string videoSource : ""
    property alias fillMode : videoOutput.fillMode
    property alias flushMode : videoOutput.flushMode


    //readonly property string videoSourceUsed :
    readonly property alias cam : camLoader.item
    elementType: "VideoElement"

    Component.onCompleted: {
        dumpedProperties.push({"name": "useCamera", "default": false});
        dumpedProperties.push({"name": "showPanel", "default": true});
        dumpedProperties.push({"name": "videoSource", "default": ""});
        dumpedProperties.push({"name": "fillMode", "default": VideoOutput.PreserveAspectFit});
        dumpedProperties.push({"name": "flushMode", "default": VideoOutput.FirstFrame});

        if (cam){
            if (useCamera)
                cam.start();
            else cam.stop();
        }

    }

    hoverEnabled:true

    Loader{
        id:camLoader
        active:root.useCamera
        sourceComponent:Camera{}
    }

    MediaPlayer {
        id: player
        source: pm.lookForLocalFile(root.videoSource)//"file:///Users/charby/Downloads/Sintel.mp4"
        //onSourceChanged:console.log("Video source:"+source)
        //autoPlay: true
        autoLoad: true
        volume:1

    }



    contentItem: VideoOutput{
        id:videoOutput
        source:root.useCamera ? cam : player
        autoOrientation: true
        fillMode:VideoOutput.PreserveAspectFit
        flushMode:VideoOutput.FirstFrame

        Item{
            visible:!root.useCamera && root.showPanel && ( (player.playbackState !== MediaPlayer.PlayingState) || root.hovered)
            anchors.fill: parent

            FAButton{
                width:0.3 * Math.min(parent.width,parent.height)
                height: width
                icon:FontAwesome.playCircle
                visible:player.playbackState !== MediaPlayer.PlayingState
                decorate: false
                onClicked: player.play()
                anchors.centerIn: parent
            }
            RowLayout{
                width:parent.width
                anchors.bottom:parent.bottom
                visible:player.availability === MediaPlayer.Available
                FAButton{
                    icon:FontAwesome.backward
                    enabled: player.seekable
                    onClicked: player.seek(Math.max(0,player.position - 1000))
                }
                FAButton{
                    icon:(player.playbackState === MediaPlayer.PlayingState ) ? FontAwesome.pause : FontAwesome.pause
                    onClicked: (player.playbackState === MediaPlayer.PlayingState ) ? player.pause() : player.play()

                }
                FAButton{
                    icon:FontAwesome.forward
                    enabled: player.seekable
                    onClicked: player.seek(Math.min(player.duration,player.position + 1000))
                }
                Slider{
                    Layout.fillWidth: true
                    enabled:player.seekable
                    from:0
                    to:player.duration
                    value:player.position
                    onMoved: player.seek(value)

                }
            }
        }

        Item{
            visible:root.useCamera
            anchors.fill: parent
            FAButton{
                width:0.3 * Math.min(parent.width,parent.height)
                height: width
                icon:FontAwesome.playCircle
                decorate: false
                onClicked: cam.start()
                anchors.centerIn: parent
            }
        }

        Label{
            color:"red"
            text:videoOutput.source.errorString
            anchors.fill: parent
        }
    }

    editorComponent: Component {
        Column {
            width:parent.width

            GroupBox{
                title:qsTr("useCamera")
                width:parent.width
                CheckBox{
                    checked: target.useCamera
                    onToggled: target.useCamera = checked
                    width:parent.width
                }
            }

            GroupBox{
                title:qsTr("Video source")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.videoSource : ""
                    onTextEdited: target.videoSource = text
                    onEditingFinished: target.videoSource = text
                }
            }

            GroupBox{
                title:qsTr("fillMode")
                width:parent.width
                ComboBox{
                    width:parent.width
                    model: ["Stretch", "PreserveAspectFit", "PreserveAspectCrop"]
                    currentIndex: currentIndex = target.fillMode
                    onActivated: target.fillMode = currentIndex
                }
            }
            GroupBox{
                title:qsTr("flushMode")
                width:parent.width
                ComboBox{
                    width:parent.width
                    model: ["EmptyFrame", "FirstFrame", "LastFrame"]
                    currentIndex: currentIndex = target.flushMode
                    onActivated: target.flushMode = currentIndex
                }
            }



        }
    }
}
