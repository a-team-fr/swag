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
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls.Material 2.14
import fr.ateam.swag 1.0
import FontAwesome 1.0
import MaterialIcons 1.0
import Swag 1.0

Control{
    id:root
    property alias icon : icon.text
    property alias text : label.text
    property color color : Material.foreground
    property color iconColor : color
    property bool decorate : true
    property alias horizontalAlignment : label.horizontalAlignment

    readonly property bool down : mouseArea.pressed || checked

    property bool autoFitText : false

    property bool toggleButton : false
    property bool checked : false

    property bool useFontAwesome : false

    property color borderColor : down ? Qt.lighter(Material.backgroundColor,4) : Qt.lighter(Material.backgroundColor,3)
    property int borderWidth : 0

    property color backgroundHoveredColor : Qt.lighter(Material.backgroundColor, 2 )
    property color backgroundColor : Qt.lighter(Material.backgroundColor,1.5 * (down ? 2 :1))

    property bool rounded : false


    background: Rectangle {
        visible:root.decorate
        color: root.hovered ? root.backgroundHoveredColor : root.backgroundColor
        opacity: enabled ? 1 : 0.3
        border.color: root.borderColor
        border.width: root.borderWidth
        radius: root.rounded ? root.width / 2 : 2
    }
    padding: 3
    horizontalPadding: padding + 2
    spacing: 3
    topInset: 0
    bottomInset: 0
    leftInset:0
    rightInset: 0


    implicitHeight : 30
    implicitWidth : label.contentWidth + 50

    signal clicked()
    signal doubleClicked()

    contentItem:RowLayout{
        id:content
        opacity : root.enabled ? 1 : 0.4
        Text{
            id:icon
            font.family: root.useFontAwesome ? FontAwesome.fontFamily : MaterialIcons.fontFamily
            //font.weight : Font.Black
            //font.styleName: "solid"
            width:visible ? root.height : 0
            color: root.iconColor
            Layout.maximumHeight:root.height - 2*root.padding
            Layout.fillWidth: true
            height:parent.height
            Layout.maximumWidth:visible ? root.height :0
            font.pointSize: 50
            minimumPointSize: 10
            fontSizeMode: Text.Fit
            visible:text.length
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter
        }
        Label{
            id:label
            color: root.color
            Layout.fillWidth: true
            height:root.height
            elide: Text.ElideRight
            font.pointSize: root.autoFitText ? 50 : 14
            minimumPointSize: 1
            fontSizeMode: root.autoFitText ? Text.Fit : Text.FixedSize
            visible:text.length
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter
        }

    }

    MouseArea{
        id:mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked()
            if (root.toggleButton)
                root.checked = !root.checked
        }
        onDoubleClicked: root.doubleClicked()
    }
}
