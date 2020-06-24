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
import MaterialIcons 1.0
import FontAwesome 1.0
import QtQuick.Controls.Material 2.12
import QtMultimedia 5.12
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.14

Pane {


    ListModel{
        id:lstPages
        ListElement{
            //![Swag logo](https://user-images.githubusercontent.com/9682519/78088227-cfc78d80-73c3-11ea-82ae-b3f91b1375dd.png)
            text:qsTr("
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



    Row{
        anchors.fill: parent
        anchors.margins: 5
        spacing : 20

        Frame {
            id:leftFrame
            width : ( parent.width - parent.spacing) / 2
            height :parent.height - 50
            //opacity : animation.playing? 0 : 1 //opacityMask.visible ? 0 : 1
            //Behavior on opacity{ NumberAnimation { duration: 1000 } }

            Image{
                id:logo
                width : 200; height : 50;
                fillMode :Image.PreserveAspectFit
                source:"qrc:/res/logo.png"
                opacity : (animation.opacity == 0 || !animation.visible) ? 1 : 0
                MouseArea{
                    anchors.fill : parent
                    onClicked: { animation.playing = true; animation.visible=true}
                }

            }
            AnimatedImage{
                id:animation
                source:"file:///Users/charby/Documents/Git/swag/res/wh.gif"
                anchors.centerIn: parent
                width:Math.min(leftFrame.width, leftFrame.height) ; height: width
                fillMode :Image.PreserveAspectFit
                Component.onCompleted : { playing = NavMan.welcomeAnimation; visible = NavMan.welcomeAnimation}
                onPlayingChanged: NavMan.welcomeAnimation = playing

                opacity : playing ? 1 : 0
                Behavior on opacity{ enabled: animation.playing; NumberAnimation { duration: 1000 } }
                Behavior on x{ NumberAnimation { duration: 1000 } }
                Behavior on y{ NumberAnimation { duration: 1000 } }
                Behavior on height{ enabled: !animation.playing; NumberAnimation {  duration: 1000 } }
                Behavior on width{ enabled: !animation.playing; NumberAnimation {  duration: 1000 } }
                speed : 0.8


                states: [
                    State {
                        when: !animation.playing

                        PropertyChanges{
                            target:animation
                            x:0; y : 0; width : 200; height:50;
                            anchors.centerIn: undefined
                        }


                    }
                ]
            }

            ListView{
                id:view
                opacity : 1 - animation.opacity
                y : 50
                height: parent.height - 100
                width: parent.width
                clip: true
                model: lstPages
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

            RowLayout{
                anchors.top : view.bottom
                opacity : 1 - animation.opacity
                width:parent.width
                FAButton{
                    icon :MaterialIcons.keyboard_arrow_left
                    decorate : false
                    opacity: view.currentIndex > 0 ? 1 : 0
                    onClicked:view.decrementCurrentIndex()

                }
                PageIndicator {
                    Layout.alignment: Qt.AlignHCenter

                    count: view.count
                    currentIndex: view.currentIndex
                }

                FAButton{
                    icon : MaterialIcons.keyboard_arrow_right
                    decorate : false
                    opacity : (view.currentIndex !== view.count -1) ? 1 : 0
                    onClicked:view.incrementCurrentIndex()

                }
            }


        }

        ColumnLayout{
            width : ( parent.width - parent.spacing) / 2
            height :parent.height

            spacing : 50

            FAButton{
                Layout.alignment: Qt.AlignHCenter
                Layout.minimumHeight : 50
                Layout.minimumWidth : 250
                iconColor: Material.accent
                color: Material.accent
                text:qsTr("Register or login")
                onClicked: pm.displayType = PM.WPConnect
                icon: FontAwesome.signInAlt
                visible : !pm.wp.loggedIn
                useFontAwesome: true

            }

            FAButton{
                Layout.alignment: Qt.AlignHCenter
                Layout.minimumHeight : 50
                Layout.minimumWidth : 250
                iconColor: Material.accent
                color: Material.accent
                icon : MaterialIcons.create_new_folder
                text:qsTr("Create a new Swag")
                onClicked:pm.create("")
            }

            FAButton{
                Layout.alignment: Qt.AlignHCenter
                Layout.minimumHeight : 50
                Layout.minimumWidth : 250
                iconColor: Material.accent
                color: Material.accent
                icon : MaterialIcons.stars
                text:qsTr("Open gallery example")
                onClicked:pm.load("")
            }


            GroupBox{
                id:followGroup
                title:qsTr("Follow a live Swag :")
                Layout.fillWidth: true
                RowLayout{
                    width:parent.width
                    height:channelSelect.height
                    Label{
                        text:qsTr("There is currently no live presentation")
                        visible : pm.net.lstChannels.length === 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    ComboBox{
                        id:channelSelect
                        Layout.fillWidth: true
                        model:pm.net ? pm.net.lstChannels : null
                        textRole: "channel"
                        enabled : pm.net ? !pm.net.following : false
                        Component.onCompleted: currentIndex = indexOfValue( pm.net ? pm.net.channel : "")
                        visible : pm.net.lstChannels.length > 0

                    }
                    FAButton{
                        height:channelSelect.height
                        enabled: channelSelect.currentText.length > 0
                        onClicked: pm.net.modifyChannel(channelSelect.enabled ? channelSelect.currentText : "0", false);
                        ToolTip.visible:hovered
                        ToolTip.text : channelSelect.enabled ? qsTr("Follow") : qsTr("Leave")
                        icon: channelSelect.enabled ? MaterialIcons.phonelink : MaterialIcons.phonelink_off
                        visible : pm.net.lstChannels.length > 0
                    }

                }

            }


            //History
            GroupBox{
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible : lstLastOpened.count
                title:qsTr("Recently opened swags ")
                ListView{
                    id:lstLastOpened
                    anchors.fill : parent
                    model : pm.lastOpenedFiles
                    delegate: ItemDelegate{
                        width : lstLastOpened.width
                        text:modelData.replace(pm.slideDecksFolderPath+'/',"") + ".swag"
                        onClicked:pm.load(modelData+".swag")

                        FAButton{
                            anchors.right:parent.right
                            height:parent.height
                            width:height
                            iconColor: NavMan.settings.materialAccent
                            decorate: false
                            onClicked : pm.removeLastOpenedFilesEntry(index)
                            icon: MaterialIcons.remove_circle_outline
                        }
                    }
                }
            }
        }
    }

    Row{
        anchors.bottom : parent.bottom
        x: leftFrame.width - width
        spacing : 1
        Label{ text:qsTr("Theme selection "); height:parent.height; verticalAlignment : Text.AlignVCenter }
        FAButton{
            icon: MaterialIcons.landscape
            checked : NavMan.settings.materialTheme === Material.Dark
            onClicked:{
                NavMan.settings.materialTheme = Material.Dark
                //Load a default presettings for dark
                NavMan.settings.materialAccent = "#FFE082"
                NavMan.settings.materialBackground = "#303030"
                NavMan.settings.materialForeground = "White"
                NavMan.settings.materialPrimary = "#80CBC4"
                NavMan.settings.materialElevation = 11
            }
        }
        FAButton{
            icon: MaterialIcons.panorama
            checked : NavMan.settings.materialTheme === Material.Light
            onClicked:{
                NavMan.settings.materialTheme = Material.Light
                //Load a default presettings for light
                NavMan.settings.materialAccent = "#4CAF50"
                NavMan.settings.materialBackground = "#CFCFCF"
                NavMan.settings.materialForeground = "#607D8B"
                NavMan.settings.materialPrimary = "#CDDC39"
                NavMan.settings.materialElevation = 11
            }
        }
    }
}

