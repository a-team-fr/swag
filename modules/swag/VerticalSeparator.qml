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

Rectangle {
    id: sep
    property real position: 0.5
    x: visible ? (position * parent.width) - width/2 : 0
    width: 4
    height: parent.height
    color: "grey"

    MouseArea {
        id: mouseArea
        anchors.fill:  parent
        anchors.margins: -5

        drag {
            target: parent
            axis: Drag.XAxis
            minimumX: -parent.width/2
            maximumX: sep.parent.width
        }
        onPositionChanged:  {
            if (drag.active)
                sep.position = mouseX / sep.parent.width
        }
    }
}

