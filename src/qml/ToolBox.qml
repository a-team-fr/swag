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
import MaterialIcons 1.0
import fr.ateam.swag 1.0
import Swag 1.0

Frame{
    width:visible ?  70: 0
    height:parent.height
    Component.onCompleted: {
        if (NavMan.settings.loadElement3d)
            lstTools.append({icon:"\ue25f", elementType:"Entity3DElement.qml",tooltip:qsTr("Add a 3D element")})
    }
    ListModel{
        id:lstTools
        ListElement{
            icon: "\ue262" //MaterialIcons.text_fields
            elementType:"TextElement.qml"
            tooltip:qsTr("Add a text element")
        }
        ListElement{
            icon: "\ue86f"//MaterialIcons.code
            elementType:"CodeElement.qml"
            tooltip:qsTr("Add a code element")
        }
        ListElement{
            icon: "\ue06c" //MaterialIcons.call_to_action
            elementType:"ButtonElement.qml"
            tooltip:qsTr("Add a button element")
        }
        ListElement{
            icon: "\ue410"//MaterialIcons.photo
            elementType:"ImageElement.qml"
            tooltip:qsTr("Add a image element")
        }
        ListElement{
            icon: "\ue2bd"//MaterialIcons.cloud
            elementType:"WebElement.qml"
            tooltip:qsTr("Add a Web element")
        }
        ListElement{
            icon: "\ue415"//MaterialIcons.picture_as_pdf
            elementType:"PDFElement.qml"
            tooltip:qsTr("Add a PDF element")
        }
        ListElement{
            icon: "\ue3c9"//MaterialIcons.edit
            elementType:"InputElement.qml"
            tooltip:qsTr("Add an Input element")
        }
        ListElement{
            icon: "\ue55b"//MaterialIcons.map
            elementType:"MapElement.qml"
            tooltip:qsTr("Add a Map element")
        }
        ListElement{
            icon: "\ue8af"//MaterialIcons.question_answer
            elementType:"FlipableElement.qml"
            tooltip:qsTr("Add an Flipable element")
        }
        ListElement{
            icon: "\ue1db"//MaterialIcons.storage
            elementType:"DataElement.qml"
            tooltip:qsTr("Add a Data element")
        }
        ListElement{
            icon: "\ue801"//MaterialIcons.poll
            elementType:"MCQElement.qml"
            tooltip:qsTr("Add an MCQ element")
        }
        ListElement{
            icon: "\ue24b"//MaterialIcons.insert_chart
            elementType:"ChartElement.qml"
            tooltip:qsTr("Add a Chart element")
        }
        ListElement{
            icon: "\ue6dd"//MaterialIcons.bubble_chart
            elementType:"DatavizElement.qml"
            tooltip:qsTr("Add a Dataviz element")
        }
        ListElement{
            icon: "\ue04a"//MaterialIcons.video_library
            elementType:"VideoElement.qml"
            tooltip:qsTr("Add a Video element")
        }
        ListElement{
            icon: "\ue8de"//MaterialIcons.toc
            elementType:"TocElement.qml"
            tooltip:qsTr("Add a Table of Content element")
        }
//        ListElement{
//            icon: "\uf1b3"//FontAwesome.cubes
//            elementType:"Entity3DElement.qml"
//            tooltip:qsTr("Add a 3D element")
//        }
    }

    Flickable {
        contentHeight: content.childrenRect.height + 50
        anchors.fill : parent
        anchors.margins: 1
        clip:true

        Column{
            id:content
            anchors.fill:parent
            anchors.margins:5
            spacing: 15
            Repeater{
                model:lstTools
                delegate:FAButton{
                    icon:model.icon
                    width:content.width
                    height : 75
                    onClicked:NavMan.currentSlide.createElement(model.elementType)
                    hoverEnabled:true
                    ToolTip.visible: hovered
                    ToolTip.text: model.tooltip
                }
            }

        }

    }
}
