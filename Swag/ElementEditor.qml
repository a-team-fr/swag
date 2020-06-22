
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
import QtQuick.Controls 2.12
import fr.ateam.swag 1.0
import Swag 1.0
import MaterialIcons 1.0
import QtQuick.Layouts 1.14

Frame {
    id: root
    property var target: NavMan.elementItemToModify
    onTargetChanged: pages.reload();
    signal done

    Component {
        id: baseElementProperties
        Column {
            width: parent.width
            spacing : 2
            TextFieldDelegate{
                title: qsTr("Id")
                width: parent.width
                text: target ? target.idAsAString : ""
                onEditingFinished: {
                    //TODO : check unicity of id among slide elements
                    //TODO : enforce naming policy
                    target.idAsAString = text
                    //save & reload right away to get a proper id
                    NavMan.actionReloadSlide(true);
                }
            }

            TextFieldDelegate{
                title: qsTr("z")
                width: parent.width
                text: target ? target.z : 0
                onEditingFinished: target.z = Number(text)
                content.validator: IntValidator{}
            }

            TextFieldDelegate{
                title: qsTr("rotation")
                width: parent.width
                text: target ? target.rotation : 0
                onEditingFinished: target.rotation = Number(text)
                content.validator: DoubleValidator{}
            }

            SwitchDelegate {
                width: parent.width
                text:qsTr("navigationFocus")
                checked: target ? target.navigationFocus : false
                onToggled: target.navigationFocus = checked
            }

        }
    }

    ListModel {
        id: pages
        function reload() {
            clear()
            append({
                       "groupTitle": qsTr("Basic properties"),
                       "component": baseElementProperties
                   })
            if (root.target && root.target.editorComponent)
                append({
                           "groupTitle": root.target.elementType,
                           "component": root.target.editorComponent
                       })
        }

    }


    ListView {
        id: layout
        anchors.fill:parent
        anchors.bottomMargin: footer.height + 10
        clip: true
        model: pages
        currentIndex: count -1
        contentHeight: childrenRect.height
        delegate: Column {
            clip: true
            width: layout.width
            height: (index === layout.currentIndex) ? propertyTitle.height + propertyContent.height : propertyTitle.height
            ItemDelegate {
                id: propertyTitle
                highlighted: true
                text: model.groupTitle
                width: parent.width
                onClicked: layout.currentIndex = index
                font.pixelSize: 16
                font.bold: true
                font.underline: true



            }

            Loader {
                id: propertyContent
                width: parent.width
                visible: (index === layout.currentIndex)
                sourceComponent: model.component
                property var target: root.target
            }
        }
    }

    Column{
        id:footer
        width:parent.width
        height : childrenRect.height
        anchors.bottom: parent.bottom
        spacing : 3

        FAButton{
            //decorate:false
            icon:MaterialIcons.crop
            width:parent.width
            text: qsTr("Resize and reposition")
            onClicked: NavMan.elementItemToPosition = target
        }

        FAButton{
            //decorate:false
            icon:MaterialIcons.save
            width:parent.width
            text: qsTr("save slide")
            onClicked: NavMan.actionSave()
        }

        FAButton{
            icon:MaterialIcons.remove
            color:"red"
            width: parent.width
            text: qsTr("Remove element")
            onClicked: {
                target.destroy()
                NavMan.actionReloadSlide(false);
            }

        }
    }



}
