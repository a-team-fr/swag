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
import QtQuick.Dialogs 1.2
import MaterialIcons 1.0
import fr.ateam.swag 1.0
import Swag 1.0

Popup{
    id:root
    implicitHeight : 300
    implicitWidth : 400

    property string currentIcon : ""
    property bool closeAtSelection : true

    ScrollView{
        id : scroll
        anchors.fill:parent
        anchors.margins: 5
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip : true
        Flow{
            width:scroll.width
            spacing : 5
            Repeater{
                model: ListMaterialIcons{}
                delegate: FAButton{
                    icon : value
                    ToolTip.visible: hovered
                    ToolTip.text : name
                    onClicked: {
                        root.currentIcon = name
                        if (root.closeAtSelection)
                            root.close()
                    }
                }
            }
        }


    }
}
