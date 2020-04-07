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
import QtQuick.Controls.Material 2.14
import fr.ateam.swag 1.0
import Swag 1.0
//import FontAwesome 1.0


Element {
    id: root

    property color textColor : Material.foreground
    elementType: "TocElement"

    Component.onCompleted: {
        //dumpedProperties.push({"name": "useCamera", "default": false});

    }

    contentItem: ListView{
        id:view
        model: pm.lstSlides
        clip:true
        delegate:FAButton{
            width:view.width
            height:30
            decorate:false
            hoverEnabled: true
            color: hovered ? Qt.darker(root.textColor) : root.textColor
            horizontalAlignment: Text.AlignLeft
            text:index + " - "+ modelData["title"]
            onClicked:pm.selectSlide(index)
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
