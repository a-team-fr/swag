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
import Swag 1.0

Control{
    id:root
    property alias title : label.text
    property alias text : input.text
    property alias horizontalAlignment : label.horizontalAlignment
    property bool autoFitLabel : false
    property int labelMinimumWidth : -1
    property int labelMaximumWidth : -1
    property alias labelColor : label.color

    property bool showButton : false
    property bool showTextField : !showComboBox
    property bool showComboBox : cb.count > 0

    property alias comboBox : cb

    property alias echoMode: input.echoMode
    property alias readOnly: input.readOnly
    property alias placeholderText: input.placeholderText
    property alias placeholderTextColor: input.placeholderTextColor

    //TextField signal
    signal editingFinished()
    signal accepted()
    signal textEdited()
    //Button signal
    signal confirmed()
    //combobox: signal
    signal activated()
    signal currentTextChanged()


    padding: 3
    horizontalPadding: padding + 2
    spacing: 3
    topInset: 0
    bottomInset: 0
    leftInset:0
    rightInset: 0

    implicitHeight : contentItem.height + padding * 2
    implicitWidth : 50


    contentItem:RowLayout{
        height : childrenRect.height
        spacing : 15
        Label{
            id:label
            //Layout.fillWidth: true
            color : Material.accent
            Layout.minimumWidth : root.labelMinimumWidth
            Layout.maximumWidth : root.labelMaximumWidth
            elide: Text.ElideRight
            font.pointSize: root.autoFitLabel ? 50 : 14
            minimumPointSize: 1
            fontSizeMode: root.autoFitLabel ? Text.Fit : Text.FixedSize
            visible:text.length
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter
        }

        TextField{
            id:input
            Layout.fillWidth: true
            onEditingFinished : root.editingFinished()
            onAccepted: root.editingFinished()
            onTextEdited : root.textEdited()
            visible: root.showTextField

        }

        ComboBox{
            id:cb
            Layout.fillWidth: true
            visible : root.showComboBox
            onActivated: root.activated()
            onCurrentTextChanged : root.currentTextChanged()
        }

        Button{
            text:"..."
            id:confirmButton
            visible : root.showButton
            onClicked: root.confirmed()
        }

    }


}
