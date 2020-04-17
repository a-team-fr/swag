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

RowLayout{
    width:parent.width
    height : 40
    id:footer


    Switch{
        text:qsTr("Edit")
        checked: NavMan.editMode
        onToggled: NavMan.actionEditMode()
        height:footer.height

    }

    FAButton{
        icon:FontAwesome.arrowLeft
        onClicked:NavMan.actionPrevious(true)
        opacity : pm.slideSelected > 0 ? 1 : 0
        decorate:false
    }
    FAButton{
        icon:FontAwesome.arrowCircleLeft
        onClicked: NavMan.actionPrevious(false)
        visible : NavMan.navigationManagedBySlide && !NavMan.viewWorldMode
        decorate:false
    }
    Label{
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
            height:150
            opacity:0.7
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            dim:false
            //modal:true
            TocElement{
                anchors.fill: parent
            }
        }


    }

    FAButton{
        icon:FontAwesome.arrowCircleRight
        onClicked:NavMan.actionNext(false)
        visible : NavMan.navigationManagedBySlide  && !NavMan.viewWorldMode
        decorate:false
    }
    FAButton{
        icon:FontAwesome.arrowRight
        onClicked:NavMan.actionNext(true)
        decorate:false
    }
    Label{
        Layout.fillWidth: true
        text: pm.loaded ? pm.prezProperties.title + qsTr(" ( GPLv3 licensed )") : ""
        visible:!NavMan.editMode
    }
    TextField{
        Layout.fillWidth: true
        text:pm.loaded ? pm.prezProperties.title : ""
        onTextEdited: pm.savePrezSettings("title", pm.prezProperties.title)
        visible:NavMan.editMode
    }

}
