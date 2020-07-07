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
import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import MaterialIcons 1.0
import fr.ateam.swag 1.0
import Swag 1.0

Control{
    id:root

    property int slideWidth : parent ? parent.width : NavMan.slideWidth //from Navigator, the slide should be rendered without using NavMan.slideWidth
    property int slideHeight : parent ? parent.height : NavMan.slideWidth

    property bool editable : true //can be modifed in editmode by the user

    function rebindGeometry(){
        x = Qt.binding( function(){ return xRel*slideWidth; } )
        y = Qt.binding( function(){ return yRel*slideHeight; } )
        width = Qt.binding( function(){ return widthRel*slideWidth; } )
        height = Qt.binding( function(){ return heightRel*slideHeight; } )
    }

    function setX( val){
        xRel = val / slideWidth
    }
    function setY( val){
        yRel = val / slideHeight
    }
    function setWidth( val){
        widthRel = val / slideWidth
        //console.log("new widthRel:"+widthRel)
    }
    function setHeight( val){
        heightRel = val / slideHeight
    }
    function updateGeometry(ptTopLeft, ptBottomRight){
        setX ( ptTopLeft.x)
        setY ( ptTopLeft.y)
        setWidth(ptBottomRight.x - ptTopLeft.x)
        setHeight(ptBottomRight.y - ptTopLeft.y)
    }

    //Element properties
    property string idAsAString:""
    property bool notToBeSaved : false //Skip during saving (implemented but not used)
    property string elementType : "Element"
    property var dumpedProperties:[ {"name":"navigationFocus","default":false},
        {"name":"idAsAString","default":""},
        {"name":"opacity","default":1},
        {"name":"xRel","default":0},
        {"name":"yRel","default":0},
        {"name":"widthRel","default":0},
        {"name":"heightRel","default":0}]
//    property var dumpedProperties:[ {"name":"navigationFocus","default":false},
//        {"name":"idAsAString","default":""},
//        {"name":"x","default":0},
//        {"name":"y","default":0},
//        {"name":"width","default":0},
//        {"name":"height","default":0}]

    property bool navigationFocus : false


    property double xRel : 0
    property double yRel : 0
    property double widthRel : 0
    property double heightRel : 0

    x : slideWidth * xRel
    y : slideHeight * yRel
    width: slideWidth * widthRel
    //onWidthChanged: console.log("new width:"+width)
    height: slideHeight * heightRel


    readonly property bool isMe : root === NavMan.elementItemToModify

    property var editorComponent : null



    background:Item{
        visible:(isMe || root.hovered) && pm.editMode && root.editable
        enabled:visible
        z:50
        //bounding rect (gives editing focus on click)
        Rectangle{
            anchors.fill: parent
            border.color:NavMan.settings.materialAccent
            border.width: isMe ? 3 : 1
            radius:10
            color:"transparent"
            MouseArea{
                //enabled: !NavMan.elementItemToPosition
                anchors.fill: parent
                preventStealing: true
                propagateComposedEvents: true
                onClicked: {
                    if (!root.isMe)
                        NavMan.displayEditElement( root)
                }
            }
            //dimension of the element at the bottom of the bounding rect
            Label{
                text:root.width.toFixed(0) + " x " + root.height.toFixed(0)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top : parent.bottom
                color : NavMan.settings.materialAccent
                font.pixelSize : 10
            }
        }


        //topLeft grip
        Rectangle{
            id:topLeft
            width :20; height : width;
            radius : 0; color: NavMan.settings.materialAccent
            MouseArea{
                anchors.fill:parent
                drag.target : root
                drag.axis: Drag.XAndYAxis
                drag.minimumX: 0
                drag.maximumX: root.slideWidth - root.width
                drag.minimumY: 0
                drag.maximumY: root.slideHeight - root.height
                onPressed: parent.color = NavMan.settings.materialPrimary
                onReleased: {
                    parent.color = NavMan.settings.materialAccent
                    root.setX(topLeft.x + root.x)
                    root.setY(topLeft.y + root.y)
                    rebindGeometry()
                }
                Label{
                    text:"x:"+root.x.toFixed(0) + ", y:" + root.y.toFixed(0)
                    anchors.right: parent.left
                    anchors.bottom : parent.top
                    color : NavMan.settings.materialPrimary
                    font.pixelSize : 10
                    visible : parent.pressed
                }
            }

        }
        FAButton{
            x:root.width - width;
            icon:MaterialIcons.icondelete
            color:"red"
            decorate:false
            //backgroundColor: "red"//NavMan.settings.materialAccent
            ToolTip.text: qsTr("Remove element")
            ToolTip.visible : hovered
            onClicked: {
                root.destroy()
                NavMan.actionReloadSlide(false);
            }

        }
        Rectangle{
            id:bottomRight
            x:root.width - width; y : root.height - height
            width :20; height : width;
            radius : 10; color: NavMan.settings.materialAccent

            MouseArea{
                anchors.fill:parent
                drag.target : parent
                drag.axis: Drag.XAndYAxis
                drag.minimumX: topLeft.x+50 //minimum width
                drag.maximumX: root.slideWidth - topLeft.x - root.x- 20
                drag.minimumY: topLeft.y+20
                drag.maximumY: root.slideHeight - topLeft.y -root.y - 20
                onPressed: parent.color = NavMan.settings.materialPrimary
                onReleased: {
                    parent.color = NavMan.settings.materialAccent
                    root.setWidth(resizingRect.width)
                    root.setHeight(resizingRect.height)
                    rebindGeometry()
                }
                Label{
                    text:"x:"+(bottomRight.x + 20 + root.x).toFixed(0) + ", y:" + (bottomRight.y+ 20 + root.y).toFixed(0)
                    anchors.left: parent.right
                    anchors.top : parent.bottom
                    color : NavMan.settings.materialPrimary
                    font.pixelSize : 10
                    visible : parent.pressed
                }
                Rectangle{
                    id:resizingRect
                    visible : parent.drag.active
                    x: -bottomRight.x
                    y: -bottomRight.y
                    radius : 10
                    width: bottomRight.x+ 20
                    height: bottomRight.y + 20
                    color:"transparent"
                    border.width:1; border.color : NavMan.settings.materialPrimary

                    //dimension of the element at the bottom of the bounding rect
                    Label{
                        text:resizingRect.width.toFixed(0) + " x " + resizingRect.height.toFixed(0)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top : parent.bottom
                        color : NavMan.settings.materialPrimary
                        font.pixelSize : 10
                    }
                }
            }

        }


    }


}

