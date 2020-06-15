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
import QtQuick.Layouts 1.12
import fr.ateam.swag 1.0
import Swag 1.0


ItemDelegate {
    id:root
    property string title:title.text
    signal editingFinished(string text)
    property alias content:textField

    implicitWidth : 200
    implicitHeight : 59

    contentItem: RowLayout{
        width:root.width
        Label{
            id:title
            text : root.title + " : "
            elide: Text.ElideMiddle
            Layout.maximumWidth: parent.width / 2
        }
        TextField{
            id:textField
            Layout.alignment: Qt.AlignRight
            Layout.maximumWidth: parent.width / 2
            Layout.fillWidth: true
            placeholderText: qsTr("fill in %1").arg(root.title)
            text:root.text
            onEditingFinished: root.editingFinished(text)
        }
    }

    onClicked: textField.forceActiveFocus()
}
