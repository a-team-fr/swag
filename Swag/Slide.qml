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
import QtQml.Models 2.13
import fr.ateam.swag 1.0
import QtQuick.Layouts 1.12


Control{
    id:slide
    background: Qt.createQmlObject(pm.defaultBackground, parent)
    property string elementType : "Slide"

    //Component.onCompleted : console.log("slide dimensions :"+width + "x" + height)

    property var dumpedProperties:[]
//    property var dumpedProperties:[
//        {"name":"x","default":0},
//        {"name":"y","default":0},
//        {"name":"width","default":1920},
//        {"name":"height","default":1080},
//        {"name":"rotation","default":0}]

    Item{
        id:slideBorder
        visible: pm.viewWorldMode && (slide.hovered || pt1.pressed || pt2.pressed)

        anchors.fill: parent

        Rectangle{
            x:0
            y:0
            width : pt2.parent.x + 25
            height : pt2.parent.y + 25
        border.width:5
        border.color:"purple"
        color:"transparent"
        }



        Rectangle{
            width:50; height:width; x:-width/2; y:x
            color:"blue"; radius : width/2
            MouseArea{
                id:pt1
                anchors.fill:parent
                drag.target:slide
                hoverEnabled: true
            }
        }
        Rectangle{
            width:50; height:width; x:slide.width-width/2; y:slide.height-height/2
            color:"red"; radius : width/2
            MouseArea{
                id:pt2
                hoverEnabled: true
                anchors.fill:parent
                drag.target:parent
                onReleased:{
                    slide.width = parent.x +25
                    slide.height = parent.y + 25
                }
            }
        }


    }


    property bool isSelected : slide === NavMan.currentSlide
    enabled: isSelected //|| pm.viewWorldMode
    //parent.z : isSelected ? 50 : 0
    //opacity : isSelected ? 1 : 0.7
    Behavior on opacity {  NumberAnimation { duration: 200;easing.type: Easing.InOutQuad }}

    //property var dumpedProperties:[]

    //array of item that will be displayed in full screen when using the FlatViewDisplay
    property var lstNavigationFocus : []
    Component.onCompleted: rebuildNavigationFocusList()
    function rebuildNavigationFocusList()
    {
        lstNavigationFocus.length = 0
        lstNavigationFocus.push(slide)
        applyFunctionRecursivelyIntoChildren(slide, function(obj){
            if (obj.navigationFocus)
                lstNavigationFocus.push(obj)
        })
    }

    function applyFunctionRecursivelyIntoChildren( obj, func){
        if (!obj.children) return;
        for (var i = 0; i<= obj.children.length;i++){
            var child = obj.children[i];
            if (!child) continue;
            func(child);
            applyFunctionRecursivelyIntoChildren(child, func)
        }
    }

    SlideDumper{ id:dumper; target:slide }

    function saveDocument()
    {
        dumper.saveDocument();
    }

    function createElement(url)
    {
        var component = Qt.createComponent(url);
        var obj = component.createObject(slide);
        //default size and center
        obj.width = Math.max(obj.width, 300)
        obj.height = Math.max(obj.height, 100)
        obj.x = (slide.width-obj.width) / 2;
        obj.y = (slide.height-obj.height) / 2;

        NavMan.elementItemToModify = obj
    }

    //default area to deactivate current selection
    MouseArea{
        anchors.fill:parent
        onClicked: {
            if (pm.editMode)
                NavMan.elementItemToModify = null
        }
    }


}



