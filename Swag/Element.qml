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
import fr.ateam.swag 1.0
import FontAwesome 1.0
import Swag 1.0

Control{
    id:root

    z : showEditUI ? 100 : 0
    function updateRel(ptTopLeft, ptBottomRight){
        xRel = ptTopLeft.x / refWidth
        yRel = ptTopLeft.y / refHeight
        widthRel = (ptBottomRight.x - ptTopLeft.x) / refWidth
        heightRel = (ptBottomRight.y - ptTopLeft.y) / refHeight
    }

    //Element properties
    property string idAsAString:""
    property bool notToBeSaved : false //Skip during saving (implemented but not used)
    property string elementType : "Element"
    property var dumpedProperties:[ {"name":"navigationFocus","default":false},
        {"name":"idAsAString","default":""},
        {"name":"xRel","default":0},
        {"name":"yRel","default":0},
        {"name":"widthRel","default":0},
        {"name":"heightRel","default":0}]

    property bool navigationFocus : false
    property double xRel : 0
    property double yRel : 0
    property double widthRel : 0
    property double heightRel : 0

    readonly property int refWidth : NavMan.slideWidth// (NavMan.currentSlide && NavMan.currentSlide.parent) ? NavMan.currentSlide.parent.width : 0
    readonly property int refHeight :NavMan.slideHeight//(NavMan.currentSlide && NavMan.currentSlide.parent) ? NavMan.currentSlide.parent.height : 0

    x : refWidth * xRel
    y : refHeight * yRel
    width:Math.max(refWidth * widthRel,10)
    height:Math.max(refHeight * heightRel,10)

    hoverEnabled: NavMan.editMode && !NavMan.elementItemToPosition

    readonly property bool showEditUI : (isMe || root.hovered) && NavMan.editMode && !NavMan.elementItemToPosition
    property bool isMe : root === NavMan.elementItemToModify
    property var editItem : null
    property var editorComponent : null //Component{ Rectangle{ anchors.fill:parent; color:"red"; Label{text:target.elementType; anchors.centerIn: parent}}}
    Binding{
        target: contentItem
        property: "visible"
        value:!NavMan.elementItemToPosition && ( !showEditUI || !editItem)
    }
    onEditItemChanged : editItem.parent = editContentItem

    background:Rectangle{
        visible:showEditUI || NavMan.elementItemToPosition
        enabled:visible
        border.color:"orange"
        border.width: isMe ? 3 : 1
        radius:3
        color:"transparent"
        z:50
        Item{
            id:editContentItem
            anchors.fill:parent
            visible: !NavMan.elementItemToPosition
        }
        MouseArea{
            anchors.fill: parent
            preventStealing: true
            propagateComposedEvents: true
            onClicked: NavMan.displayEditElement( root)
        }
    }


}

