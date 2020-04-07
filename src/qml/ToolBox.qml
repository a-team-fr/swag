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

Frame{
    width:visible ?  70: 0
    height:parent.height

    ListModel{
        id:lstTools
        ListElement{
            icon: "\uf0f6"//FontAwesome.fileTextO
            elementType:"TextElement.qml"
            tooltip:qsTr("Add a text element")
        }
        ListElement{
            icon: "\uf1c9"//FontAwesome.fileCodeO
            elementType:"CodeElement.qml"
            tooltip:qsTr("Add a code element")
        }
        ListElement{
            icon: "\uf144"//FontAwesome.playCircle
            elementType:"ButtonElement.qml"
            tooltip:qsTr("Add a button element")
        }
        ListElement{
            icon: "\uf1c5"//FontAwesome.fileImageO
            elementType:"ImageElement.qml"
            tooltip:qsTr("Add a image element")
        }
        ListElement{
            icon: "\uf0c2"//FontAwesome.cloud
            elementType:"WebElement.qml"
            tooltip:qsTr("Add a Web element")
        }
        ListElement{
            icon: "\uf1c1"//FontAwesome.filePdfO
            elementType:"PDFElement.qml"
            tooltip:qsTr("Add a PDF element")
        }
        ListElement{
            icon: "\uf044"//FontAwesome.pencilSquareO
            elementType:"InputElement.qml"
            tooltip:qsTr("Add an Input element")
        }
        ListElement{
            icon: "\uf278"//FontAwesome.mapO
            elementType:"MapElement.qml"
            tooltip:qsTr("Add a Map element")
        }
        ListElement{
            icon: "\uf29c"//FontAwesome.questionCircleO
            elementType:"FlipableElement.qml"
            tooltip:qsTr("Add an Flipable element")
        }
        ListElement{
            icon: "\uf1c0"//FontAwesome.database
            elementType:"DataElement.qml"
            tooltip:qsTr("Add a Data element")
        }
        ListElement{
            icon: "\uf19d"//FontAwesome.mortarBoard
            elementType:"MCQElement.qml"
            tooltip:qsTr("Add an MCQ element")
        }
        ListElement{
            icon: "\uf1fe"//FontAwesome.areaChart
            elementType:"ChartElement.qml"
            tooltip:qsTr("Add a Chart element")
        }
        ListElement{
            icon: "\uf201"//FontAwesome.lineChart
            elementType:"DatavizElement.qml"
            tooltip:qsTr("Add a Dataviz element")
        }
        ListElement{
            icon: "\uf1c8"//FontAwesome.fileVideoO
            elementType:"VideoElement.qml"
            tooltip:qsTr("Add a Video element")
        }
        ListElement{
            icon: "\uf022"//FontAwesome.listAlt
            elementType:"TocElement.qml"
            tooltip:qsTr("Add a Table of Content element")
        }
        ListElement{
            icon: "\uf1b3"//FontAwesome.cubes
            elementType:"Entity3DElement.qml"
            tooltip:qsTr("Add a 3D element")
        }
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
            spacing: 5
            Repeater{
                model:lstTools
                delegate:FAButton{
                    icon:model.icon
                    width:content.width
                    onClicked:NavMan.currentSlide.createElement(model.elementType)
                    hoverEnabled:true
                    ToolTip.visible: hovered
                    ToolTip.text: model.tooltip
                }
            }

        }

    }
}
