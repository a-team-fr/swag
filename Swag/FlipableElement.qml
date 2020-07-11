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

Element {
    id: root

    enum Mode {
        Overlapped,
        ImageLeft,
        TextLeft
    }
    property bool clickable : true

    property int frontLayout :  FlipableElement.Mode.Overlapped
    property alias frontText : _frontText.text
    property alias frontImage : _frontImage.source
    property bool frontTextFill : true

    property int backLayout : FlipableElement.Mode.Overlapped
    property alias backText : _backText.text
    property alias backImage : _backImage.source
    property bool backTextFill : true

    property alias flipped: flipable.flipped

    elementType: "FlipableElement"

    Component.onCompleted: {
        dumpedProperties.push({"name": "clickable", "default": true});

        dumpedProperties.push({"name": "frontLayout", "default": FlipableElement.Mode.Overlapped})
        dumpedProperties.push({"name": "frontText", "default": ""})
        dumpedProperties.push({"name": "frontImage", "default": ""})
        dumpedProperties.push({"name": "frontTextFill", "default": true})

        dumpedProperties.push({"name": "backLayout", "default": FlipableElement.Mode.Overlapped})
        dumpedProperties.push({"name": "backText", "default": ""})
        dumpedProperties.push({"name": "backImage", "default": ""})
        dumpedProperties.push({"name": "backTextFill", "default": true})

    }


    contentItem: Flipable {
        id:flipable
        clip:true
        front:  Frame{
            //anchors.fill:parent
            anchors.margins:5
            background:Rectangle{
                color:"grey"
                border.width:1
                border.color:"black"
            }

            Image{
                id:_frontImage
                x: (root.frontLayout === FlipableElement.Mode.TextLeft) && (root.frontText) ? width : 0
                width: visible ? ( (root.frontLayout === FlipableElement.Mode.Overlapped) ? parent.width : parent.width/2 ) : 0
                height:parent.height
                visible:root.frontImage

            }
            Label{
                id:_frontText
                x: (root.frontLayout === FlipableElement.Mode.ImageLeft) && (root.frontImage) ? width : 0
                width: visible ? ( (root.frontLayout === FlipableElement.Mode.Overlapped) ? parent.width : parent.width/2 ) : 0
                height:parent.height
                visible:root.frontText
                fontSizeMode: root.frontTextFill ? Text.Fit : Text.FixedSize
                minimumPointSize: 1
                font.pointSize: root.frontTextFill ? 50 : 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("front text")
            }
        }
        back:  Frame{
            //anchors.fill:parent
            anchors.margins:5
            background:Rectangle{
                color:"grey"
                border.width:1
                border.color:"black"
            }
            Image{
                id:_backImage
                x: (root.backLayout === FlipableElement.Mode.TextLeft) && (root.backText) ? width : 0
                width: visible ? ( (root.backLayout === FlipableElement.Mode.Overlapped) ? parent.width : parent.width/2 ) : 0
                height:parent.height
                visible:root.backImage
            }
            Label{
                id:_backText
                x: (root.backLayout === FlipableElement.Mode.ImageLeft) && (root.backImage) ? width : 0
                width: visible ? ( (root.backLayout === FlipableElement.Mode.Overlapped) ? parent.width : parent.width/2 ) : 0
                height:parent.height
                visible:root.backText
                fontSizeMode: root.backTextFill ? Text.Fit : Text.FixedSize
                minimumPointSize: 1
                font.pointSize: root.backTextFill ? 50 : 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("back text")
            }
        }

        property bool flipped: false

        transform: Rotation {
            id: rotation
            origin.x: flipable.width / 2
            origin.y: flipable.height / 2
            axis.x: 0;axis.y: 1;axis.z: 0;angle: 0;
        }

        states: State {
            name: "back"
            PropertyChanges {
                target: rotation
                angle: 180
            }
            when: flipable.flipped
        }

        transitions: Transition {
            NumberAnimation {
                target: rotation
                property: "angle"
                duration: 500
            }
        }

        MouseArea {
            enabled:root.clickable
            anchors.fill: parent
            onClicked: flipable.flipped = !flipable.flipped
        }
    }

    editorComponent: Component {
        Column {
            width: parent.width
            spacing : 3
            FormItem{
                title:qsTr("clickable")
                width: parent.width
                extraContent : Component{
                    Switch{
                        checked:target.clickable
                        onToggled: target.clickable = checked
                    }
                }

            }

            ToolSeparator{ orientation: Qt.Horizontal; width: parent.width; anchors.horizontalCenter : parent.horizontalCenter}


            FormItem{
                title:qsTr("frontLayout")
                width: parent.width
                comboBox.model: ["Overlapped", "ImageLeft", "TextLeft"]
                comboBox.currentIndex: target.frontLayout
                onActivated: target.frontLayout = comboBox.currentIndex

            }

            FormItem{
                title:qsTr("frontText")
                width:parent.width
                text:target.frontText
                onTextEdited: target.frontText = text

            }

            FormItem{
                title:qsTr("frontImage")
                width:parent.width
                text:target.frontImage
                readOnly:true
                showFilePicker: true
                onFilePicked: target.frontImage = selectedFileUrl

            }

            FormItem{
                title:qsTr("frontTextFill")
                width: parent.width
                extraContent : Component{
                    CheckBox{
                        checked:target.frontTextFill
                        onToggled: target.frontTextFill = checked
                    }
                }

            }

            ToolSeparator{ orientation: Qt.Horizontal; width: parent.width; anchors.horizontalCenter : parent.horizontalCenter}

            FormItem{
                title:qsTr("backLayout")
                width: parent.width
                comboBox.model: ["Overlapped", "ImageLeft", "TextLeft"]
                comboBox.currentIndex: target.backLayout
                onActivated: target.backLayout = comboBox.currentIndex
            }
            FormItem{
                title:qsTr("backText")
                width:parent.width
                text:target.backText
                onTextEdited: target.backText = text

            }
            FormItem{
                title:qsTr("backImage")
                width:parent.width
                text:target.backImage
                readOnly:true
                showFilePicker: true
                onFilePicked: target.backImage = selectedFileUrl
            }

            FormItem{
                title:qsTr("backTextFill")
                width: parent.width
                extraContent : Component{
                    CheckBox{
                        checked:target.backTextFill
                        onToggled: target.backTextFill = checked
                    }
                }
            }


        }
    }
}
