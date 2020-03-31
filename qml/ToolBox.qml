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
    width:visible ?  80: 0
    height:parent.height

    Flickable {
        contentHeight: content.childrenRect.height + 50
        anchors.fill : parent
        anchors.margins: 1
        clip:true

        ColumnLayout{
        id:content
        anchors.fill:parent
        FAButton{
            icon:FontAwesome.fileTextO
            onClicked:NavMan.currentSlide.createElement("TextElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a text element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.fileCodeO
            onClicked:NavMan.currentSlide.createElement("CodeElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a code element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.playCircle
            onClicked:NavMan.currentSlide.createElement("ButtonElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a button element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.fileImageO
            onClicked:NavMan.currentSlide.createElement("ImageElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add an image element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.cloud
            onClicked:NavMan.currentSlide.createElement("WebElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a web element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.filePdfO
            onClicked:NavMan.currentSlide.createElement("PDFElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a PDF element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.pencilSquareO
            onClicked:NavMan.currentSlide.createElement("InputElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add an Input element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.mapO
            onClicked:NavMan.currentSlide.createElement("MapElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a Map element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.questionCircleO
            onClicked:NavMan.currentSlide.createElement("FlipableElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a Flipable element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.database
            onClicked:NavMan.currentSlide.createElement("DataElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a Data element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.mortarBoard
            onClicked:NavMan.currentSlide.createElement("MCQElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a MCQ element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.areaChart
            onClicked:NavMan.currentSlide.createElement("ChartElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a Charts element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.lineChart
            onClicked:NavMan.currentSlide.createElement("DatavizElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a Dataviz element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.fileVideoO
            onClicked:NavMan.currentSlide.createElement("VideoElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a Video element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.listAlt
            onClicked:NavMan.currentSlide.createElement("TocElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a Table of Content element")
            Layout.alignment : Qt.AlignHCenter
        }
        FAButton{
            icon:FontAwesome.cubes
            onClicked:NavMan.currentSlide.createElement("Entity3DElement.qml")
            hoverEnabled:true
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Add a 3D element")
            Layout.alignment : Qt.AlignHCenter
        }
    }

    }
}
