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
import fr.ateam.swag 1.0


QtObject {
    id:root
    property var slide : null
    property int width : 0
    property int height : 0
    property double scale : 1
    property double rotation : 0
    property int x : 0
    property int y: 0

    readonly property var transform : [focusNav.t1,focusNav.r1,focusNav.s1,focusNav.t2,focusNav.s2,focusNav.r2]

    function previous(ForcetoSlide){ focusNav.previous(ForcetoSlide)}
    function next(ForcetoSlide){ focusNav.next(ForcetoSlide)}


    /*
    readonly property double t1x: -focusNav.x
    readonly property double t1y: -focusNav.y
    readonly property double r1Ox: focusNav.width / 2
    readonly property double r1Oy: focusNav.height / 2
    readonly property double r1rot: -focusNav.rotation
    readonly property double s1Sx: width / focusNav.width
    readonly property double s1Sy: height / focusNav.height
    readonly property double t2x: -focusNav.childx * s1Sx
    readonly property double t2y: -focusNav.childy * s1Sy
    readonly property double s2Sx: scale * focusNav.width / focusNav.childwidth
    readonly property double s2Sy: scale * focusNav.height / focusNav.childheight
    readonly property double r2Ox: s1Sx * s2Sx * focusNav.childwidth / 2
    readonly property double r2Oy: s1Sy * s2Sy * focusNav.childheight / 2
    readonly property double r2rot: -focusNav.childrotation
    */


    property var focusNav : QtObject{
        id:focusNav
        readonly property var lstObject : root.slide.lstNavigationFocus
        property int currentIndex : 0
        readonly property int count : lstObject.length

        readonly property var currentObject : lstObject[currentIndex]
        readonly property int x: root.slide.parent.x
        readonly property int y : root.slide.parent.y
        readonly property int rotation : root.slide.parent.rotation
        readonly property int width:  root.slide.parent.width
        readonly property int height: root.slide.parent.height
//        readonly property int x: root.slide.x
//        readonly property int y : root.slide.y
//        readonly property int rotation : root.slide.rotation
//        readonly property int width:  root.slide.width
//        readonly property int height: root.slide.height


        readonly property int childx: currentObject ? currentObject.x : 0
        readonly property int childy : currentObject ? currentObject.y : 0
        readonly property int childrotation : currentObject ? currentObject.rotation : 0
        readonly property int childwidth: currentObject ? currentObject.width : parent.width
        readonly property int childheight: currentObject ? currentObject.height : parent.height

        readonly property var t1: Translate{
                x : -focusNav.x
                y : -focusNav.y
                Behavior on x { NumberAnimation { duration: 800; easing.type: Easing.InOutCubic }  }
                Behavior on y { NumberAnimation { duration: 800; easing.type: Easing.InOutCubic }  }
            }

        readonly property var r1: Rotation{
                origin.x : focusNav.width / 2
                origin.y : focusNav.height / 2
                angle: -focusNav.rotation
                Behavior on angle { NumberAnimation { duration: 800; easing.type: Easing.InOutCubic }  }
            }

        readonly property var s1: Scale{
                xScale : root.width / focusNav.width
                yScale : root.height / focusNav.height
                Behavior on xScale { NumberAnimation {  duration: 800; easing.type: Easing.InOutCubic }  }
                Behavior on yScale { NumberAnimation {  duration: 800; easing.type: Easing.InOutCubic }  }
            }
        readonly property var t2: Translate{
                x : (-focusNav.childx + root.x) * root.width / focusNav.width
                y : (-focusNav.childy + root.y) * root.height / focusNav.height
                Behavior on x { NumberAnimation { duration: 800; easing.type: Easing.InOutCubic }  }
                Behavior on y { NumberAnimation { duration: 800; easing.type: Easing.InOutCubic }  }
            }
        readonly property var s2: Scale{
                xScale : root.scale * focusNav.width / focusNav.childwidth
                yScale : root.scale * focusNav.height / focusNav.childheight
                Behavior on xScale { NumberAnimation {  duration: 800; easing.type: Easing.InOutCubic }  }
                Behavior on yScale { NumberAnimation {  duration: 800; easing.type: Easing.InOutCubic }  }
            }

        readonly property var r2: Rotation{
                origin.x : root.width / focusNav.width * root.scale * focusNav.width / focusNav.childwidth * focusNav.childwidth / 2
                origin.y : root.height / focusNav.height * root.scale * focusNav.height / focusNav.childheight * focusNav.childheight / 2
                angle: -focusNav.childrotation + root.rotation

                Behavior on angle { NumberAnimation { duration: 800; easing.type: Easing.InOutCubic }  }
            }

        function previous(ForcetoSlide){
            //console.log("showing item #"+currentIndex + " of "+count)
            if ( ForcetoSlide || (currentIndex === 0) ){
                currentIndex = 0;
                pm.previousSlide();
            }
            else currentIndex--;
        }

        function next(ForcetoSlide){
            //console.log("showing item #"+currentIndex + " of "+count)
            if  ( ForcetoSlide || ( currentIndex === (count-1) ) )
            {
                currentIndex = 0;
                pm.nextSlide()
            }
            else
                currentIndex++;
        }




    }


}
