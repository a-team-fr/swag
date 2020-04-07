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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0
import Swag 1.0
import FontAwesome 1.0

Pane {
    ListModel{
        id:lstPages
        ListElement{
            //![Swag logo](https://user-images.githubusercontent.com/9682519/78088227-cfc78d80-73c3-11ea-82ae-b3f91b1375dd.png)
            text:qsTr("<img src='https://user-images.githubusercontent.com/9682519/78088227-cfc78d80-73c3-11ea-82ae-b3f91b1375dd.png' width='50%'/>

# Swag is an effort to easily create a presentation with QML

sWag provides a set of dynamic elements :
* Basic items : rectangle, text or image, buttons
* Media : Video or Camera, Maps
* Display : charts, dataviz

But sWag is basically interpreting QML file so you can program whatever you like...")
        }
        ListElement{
            text:qsTr("# How it works ?
From the welcome page, one can either create a new swag or open and existing one.
A swag is currently handled as directory so you will need to select the parent folder of the swag content ( this might change in a near future).
<img src='https://user-images.githubusercontent.com/9682519/78081707-7bb3ad80-73b1-11ea-9567-9df20ddebe70.png' width='%REPLACE_WITH_WIDTH%' height='%REPLACE_WITH_HEIGHT%'/>
When a swag is opened, it is possible to create a new slide or clone an existing one from the drawer menu.
Enter in \"Edit mode\" (with Ctrl+D or from the edit menu) to show the toolbox (at the screen right side) with the list of Element you can integrate into your slide : a Text, an Image, a chart etc...
<img src='https://user-images.githubusercontent.com/9682519/78046008-f01d2b00-7376-11ea-91a0-92c439ecee53.png' width='%REPLACE_WITH_WIDTH%' height='%REPLACE_WITH_HEIGHT%'/>
While \"Edit mode\" is active, hover an element to display its bounding box with editing functions (repositioning, changing properties or deleting the element).
At anytime, it is possible to trigger the \"Show code\" mode to inspect the current slide QML code, edit and reload the slide to see the changes without restarting s🤘ag.
<img src='https://user-images.githubusercontent.com/9682519/78081715-82422500-73b1-11ea-88c0-dde9cd81a098.png' width='%REPLACE_WITH_WIDTH%' height='%REPLACE_WITH_HEIGHT%'/>
From the Deck settings, it is possible to choose the display mode between :
* Loader : only one slide is rendered at a time
* ListView : to swipe from one slide to another
* FlatView : to navigate from one element or slide to another in a similar manner than Prezi.
<img src='https://user-images.githubusercontent.com/9682519/78081724-85d5ac00-73b1-11ea-8980-35b23d2e5e72.png' width='%REPLACE_WITH_WIDTH%' height='%REPLACE_WITH_HEIGHT%'/>
### Toolbox
* a Text element (currently only a limited set of a text properties are supported)
* a Code element : to show code with syntax highlighting (relying on highlight.js) together with a rendered object from QML code
* GotoButton : a button to change the current slide
* Webview
* Image
* Map
* Multiple Choice Question : each choice is made of an image and/or a text. When the MCQ is validated, each choice can be flipped to show an image and/or a text.
* Chart
* Dataviz
* Video or camera
* Entity 3D : show a 3D mesh
* PDF : a pdf reader based on pdf.js
One can find an example of using these elements with the \"Gallery\" swag.")
        }
        ListElement{
            text:qsTr("# Ready ?
* Open the gallery
* or create your own sWag !")
        }

    }


    ListView{
        id:view
        width: parent.width
        height : parent.height - 50
        clip:true
        model:lstPages
        highlightFollowsCurrentItem:true
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: Qt.Horizontal
        flickableDirection: Flickable.AutoFlickDirection
        contentHeight: currentItem.height
        contentWidth:width
        highlightMoveDuration:300
        highlightMoveVelocity: -1
        delegate://ScrollView{
            //width:view.width
            //contentHeight: txt.height
            Label {
                id:txt
                width:view.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pointSize: 14
                textFormat: Text.MarkdownText
                text: model.text.replace(/%REPLACE_WITH_WIDTH%/g, Number(width)).replace(/%REPLACE_WITH_HEIGHT%/g, Number(width*0.8))

            }
        //}
    }

    FAButton{
        anchors.top: view.bottom
        anchors.left: parent.left
        icon :FontAwesome.arrowCircleLeft
        decorate : false
        visible: view.currentIndex > 0
        onClicked:view.decrementCurrentIndex()
    }
    PageIndicator {
        anchors.top: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        count: view.count
        currentIndex: view.currentIndex
    }


    FAButton{
        anchors.top: view.bottom
        anchors.right: parent.right
        icon : FontAwesome.arrowCircleRight
        decorate : false
        visible : (view.currentIndex !== view.count -1)
        onClicked:view.incrementCurrentIndex()
    }

    Row{
        anchors.top: view.bottom
        anchors.left : (view.currentIndex === 0) ? parent.left : undefined
        anchors.right : (view.currentIndex === view.count -1) ? parent.right : undefined
        visible: view.currentIndex !== 1
        spacing:5
        FAButton{
            width : 150
            icon : FontAwesome.magic
            text:qsTr("Create new")
            onClicked:pm.create("")
        }
        FAButton{
            width : 150
            icon : FontAwesome.folderOpen
            text:qsTr("Open gallery")
            onClicked:pm.load("")
        }
    }



}
