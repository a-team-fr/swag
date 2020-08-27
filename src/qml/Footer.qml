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

Row{

    //width:parent.width
    //height : 40
    id:footer

    visible:pm.loaded

    signal toggleMenu();
    property var menuToToggle : null

//    Switch{
//        text:qsTr("Edit")
//        checked: pm.editMode
//        onToggled: pm.editMode = ! pm.editMode
//        visible :  !pm.net.following
//        height:footer.height

//    }
    Item{
        height:parent.height
        width:footer.menuToToggle ? footer.menuToToggle.width : 0
        visible : footer.menuToToggle
        FAButton{
            icon:( footer.menuToToggle && footer.menuToToggle.visible) ? MaterialIcons.close : MaterialIcons.menu
            height:parent.height
            width:height
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: footer.toggleMenu()
            decorate: false
        }
    }

    FAButton{
        icon:MaterialIcons.chevron_left
        onClicked:pm.previousSlide( true );
        visible :  !pm.net.following
        enabled : pm.slideSelected > 0
        opacity : enabled ? 1 : 0
        decorate:false
        height:parent.height
    }
    FAButton{
        icon:MaterialIcons.keyboard_arrow_left
        onClicked: pm.previousSlide( false );
        visible : NavMan.navigationManagedBySlide && !pm.viewWorldMode && !pm.net.following
        decorate:false
        height:parent.height
    }
    Label{
        height:parent.height
        verticalAlignment : Text.AlignVCenter
        text: (pm.slideSelected+1) + " / " + pm.lstSlides.length
        MouseArea{
            anchors.fill:parent
            onClicked:toc.open()
        }
        Popup{
            id:toc
            y:-height
            parent:footer
            width:200
            enabled: !pm.net.following
            height:150
            opacity:0.7
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            dim:false
            //modal:true
            TocElement{
                anchors.fill: parent
                editable : false
            }
        }


    }

    FAButton{
        height:parent.height
        icon:MaterialIcons.keyboard_arrow_right
        onClicked:pm.nextSlide( false );
        visible : NavMan.navigationManagedBySlide  && !pm.viewWorldMode && !pm.net.following
        decorate:false
    }
    FAButton{
        height:parent.height
        icon:MaterialIcons.chevron_right
        onClicked:pm.nextSlide( true );
        visible :  !pm.net.following
        decorate:false
        opacity : enabled ? 1 : 0
        enabled : pm.slideSelected !== (pm.lstSlides.length -1)
    }

//    Label{
//        Layout.fillWidth: true
//        text: pm.loaded ? pm.prezProperties.title + qsTr(" ( GPLv3 licensed )") : ""
//        visible:!pm.editMode
//    }
//    TextField{
//        Layout.fillWidth: true
//        text:pm.loaded ? pm.prezProperties.title : ""
//        onTextEdited: pm.writeDocumentProperty("title", pm.prezProperties.title)
//        visible:pm.editMode
//    }

}
