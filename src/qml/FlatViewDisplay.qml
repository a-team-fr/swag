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
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import fr.ateam.swag 1.0
import Swag 1.0
import MaterialIcons 1.0

Item{
    id:root


    function applyViewWorldMode( ){
        if (pm.viewWorldMode){
            if (world.currentSlide){
            flick.contentX -= world.currentSlide.width *0.3
            flick.contentY -= world.currentSlide.height *0.3
            }
            pinchTarget.scale = 0.3
        }
        else{
            pinchTarget.scale = 1;
            pinchTarget.rotation= 0;

            flick.contentX = Qt.binding(function(){return flick.offsetX});
            flick.contentY = Qt.binding(function(){return flick.offsetY});
        }
    }


    Flickable{
        id:flick
        anchors.fill:parent
        contentX:offsetX
        contentY:offsetY
        contentWidth: 2*world.width
        contentHeight:2*world.height
        ScrollBar.horizontal: ScrollBar{ policy: pm.viewWorldMode ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff }
        ScrollBar.vertical: ScrollBar{ policy: pm.viewWorldMode ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff }

        interactive: pm.viewWorldMode
        property int offsetX : world.width
        property int offsetY : world.height


        Behavior on contentX {  NumberAnimation { duration: 800;easing.type: Easing.InOutQuad }}
        Behavior on contentY {  NumberAnimation { duration: 800;easing.type: Easing.InOutQuad }}


        //ScrollBar.horizontal.policy: pinchControl.visible ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        //ScrollBar.vertical.policy: pinchControl.visible ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff

    Rectangle{
        id:world
        x:flick.offsetX
        y:flick.offsetY
        border.color:"orange"
        border.width:pm.viewWorldMode ? 10 : 0
        color:"transparent"
        width:childrenRect.width
        height:childrenRect.height

        property var currentSlide : repeater.count ? repeater.itemAt(pm.slideSelected).item : null
        onCurrentSlideChanged: pm.updateCurrentLoadedItem(currentSlide) //NavMan.currentDocument = currentSlide

        FocusNavigator{
            id:focusNav
            slide : world.currentSlide
            scale:pinchTarget.scale
            rotation : pinchTarget.rotation
            x : 0
            y : 0

            width:NavMan.slideWidth//world.width
            height:NavMan.slideHeight//world.height
        }

        Connections{
            target:NavMan
            onViewWorldModeChanged:applyViewWorldMode()
            //onRebuildNavigationFocusList:world.currentSlide.rebuildNavigationFocusList()
            //onTriggerElementPositionner:world.currentSlide.triggerElementPositionner(element)
        }
        Connections{
            target:pm
            function onPreviousNavigationFocus( ForceToSlide) { focusNav.previous(ForcetoSlide) }
            function onNextNavigationFocus( ForceToSlide) { focusNav.next(ForcetoSlide) }
        }




        transform: focusNav.transform


        Repeater{
            id:repeater
            model:pm.lstSlides


            delegate: Loader{
                z : (index == pm.slideSelected) ? 1 : 0
                                x:pm.lstSlides[index].x ? pm.lstSlides[index].x:(index % 10)*700
                                y : pm.lstSlides[index].y ? pm.lstSlides[index].y:Math.floor(index / 10) * 550
                                rotation : pm.lstSlides[index].rotation ? pm.lstSlides[index].rotation:index * 15
                                width:NavMan.slideWidth//pm.lstSlides[index].width ? pm.lstSlides[index].width:640
                                height:NavMan.slideHeight//pm.lstSlides[index].height ? pm.lstSlides[index].height:480
                source: pm.urlSlide( index )
                //opacity: 0.4

            }
            //onLoaded: applyViewWorldMode()
        }

    }


    PinchArea{
        id:pincharea
        anchors.fill:world
        anchors.margins: -Math.max(world.width,world.height)
        z:-100

        enabled:pm.viewWorldMode



        pinch{
            target: pinchTarget
            minimumScale: 0.01
            maximumScale: 3
            dragAxis: Pinch.XAndYAxis
            minimumX: -world.width
            maximumX: world.width
            minimumY: -world.height
            maximumY: world.height
            minimumRotation: -180
            maximumRotation: 180

        }
    }
    }

    Item{
        id:pinchControl
        visible : pm.viewWorldMode

        width:root.width
        height:root.height
        Item{
            id:pinchTarget
        }


        Item{
            height:parent.height
            anchors.right:parent.right
            width:200
            Rectangle{
                anchors.fill:parent
                color:"grey"
                opacity:0.7
            }

            ScrollView{
                anchors.fill: parent
            Column{
                width:parent.width
                GroupBox{
                    title:qsTr("Slide rotation")
                    Dial{
                        from:0
                        to:360
                        onValueChanged: pm.currentSlideItem.rotation = value //NavMan.currentSlide.rotation=value
                        Label{
                            anchors.centerIn: parent
                            text:pm.currentSlideItem.rotation ? pm.currentSlideItem.rotation.toPrecision(2)+" °" : ""
                        }
                    }
                }

                FAButton{
                    icon:MaterialIcons.save
                    text:qsTr("Save changes")
                    onClicked: {
                        //FIXME : move to slide properties (needs modifying transformation in FocusNavigator)
                        pm.saveSlideSetting("x", pm.currentSlideItem.x);
                        pm.saveSlideSetting("y", pm.currentSlideItem.y);
                        pm.saveSlideSetting("width", pm.currentSlideItem.width);
                        pm.saveSlideSetting("height", pm.currentSlideItem.height);
                        pm.saveSlideSetting("rotation", pm.currentSlideItem.rotation);

                        pm.currentSlideItem.x = 0
                        pm.currentSlideItem.y = 0
                        pm.currentSlideItem.rotation = 0
                    }
                }


                FAButton{
                    id:resetPinch
                    icon:MaterialIcons.undo
                    text:qsTr("Return to normal view")
                    onClicked: {
                        pm.viewWorldMode = false
                        pm.saveSlide();
                        pm.hotReload();
                    }
                }

            }
            }
        }






    }

}
