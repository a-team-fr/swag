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
import QtQuick.Dialogs 1.3
import fr.ateam.swag 1.0
import Swag 1.0
import MaterialIcons 1.0

Control{
    id:root
    //Label
    property alias title : label.text
    property alias horizontalAlignment : label.horizontalAlignment
    property alias labelColor : label.color
    property bool autoFitLabel : false
    property int labelMinimumWidth : -1
    property int labelMaximumWidth : -1

    //TextField
    property alias textField : input
    property alias text : input.text
    property bool showTextField : !showComboBox && !showColorSelector && !showIconSelector && !root.extraContent
    property alias echoMode: input.echoMode
    property alias readOnly: input.readOnly
    property alias placeholderText: input.placeholderText
    property alias placeholderTextColor: input.placeholderTextColor
    signal editingFinished()
    signal accepted()
    signal textEdited()

    //combobox
    property bool showComboBox : cb.count > 0
    property alias comboBox : cb
    signal activated()
    signal currentTextChanged()

    //Button
    signal confirmed()
    property bool showButton : false
    property alias confirmButtonIcon : confirmButton.icon

    //color selector
    property bool showColorSelector : false
    property color selectedColor :"transparent"
    signal colorPicked()

    //icon selector
    property bool showIconSelector : false
    property string selectedIcon :""
    signal iconPicked()

    //common all picker
    property var pickerParent : root.parent

    //Extra content
    property var extraContent : null
    property bool extraContent_fillWidth : false
    property int extraContent_horizontalAlignment : Qt.AlignRight

    //filePicker
    property bool showFilePicker : false
    property var selectedFileUrl : null
    property bool selectExisting : true
    property var nameFilters:[ qsTr("All (*.*)")]
    property string defaultSuffix : ""
    property string defaultFolder : pm.currentSlideDeckPath
    signal filePicked()




    padding: 3
    horizontalPadding: padding + 2
    spacing: 3
    topInset: 0
    bottomInset: 0
    leftInset:0
    rightInset: 0

    implicitHeight : contentItem.childrenRect.height
    //implicitWidth : contentItem.childrenRect.width


    contentItem:RowLayout{
        width : parent.width
        //implicitWidth: childrenRect.width
        //implicitHeight : childrenRect.height
        //height : childrenRect.height
        spacing : 15
        Label{
            id:label
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
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        }

        TextField{
            id:input
            Layout.fillWidth: true
            selectByMouse: true
            onEditingFinished : root.editingFinished()
            onAccepted: root.editingFinished()
            onTextEdited : root.textEdited()
            visible: root.showTextField
            passwordMaskDelay: 1000
        }

        ComboBox{
            id:cb
            Layout.fillWidth: true
            visible : root.showComboBox
            onActivated: root.activated()
            onCurrentTextChanged : root.currentTextChanged()
        }

        FAButton{
            id:confirmButton
            icon : MaterialIcons.done
            visible : root.showButton
            onClicked: root.confirmed()
        }

        FAButton{
            visible : root.showFilePicker
            icon : MaterialIcons.folder_open
            onClicked:filePicker.open()

            FileDialog{
                id:filePicker
                visible: false
                folder : root.defaultFolder
                defaultSuffix : root.defaultSuffix
                nameFilters : root.nameFilters
                selectExisting : root.selectExisting
                onAccepted:{
                    root.selectedFileUrl = fileUrl
                    root.filePicked()
                }
            }
        }



        Loader{
            Layout.alignment : Qt.AlignRight
            active: root.showColorSelector
            visible : active
            height:parent.height
            width:height
            sourceComponent : Rectangle{
                border.width : 2
                border.color:"lightgrey"
                color:"white"
                Rectangle{
                    anchors.fill: parent;
                    anchors.margins:2;
                    color : root.selectedColor
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked:colorPicker.open()
                }
                ColorPicker{
                    id:colorPicker
                    currentColor : root.selectedColor
                    visible:false
                    parent : root.pickerParent
                    onSelected:{
                        root.selectedColor = currentColor
                        root.colorPicked()
                    }
                }

            }

        }

        Loader{
            Layout.alignment : Qt.AlignRight
            active: root.showIconSelector
            visible : active
            height:parent.height
            width:height

            sourceComponent: FAButton{
                anchors.fill:parent
                icon : root.selectedIcon
                onClicked:iconPicker.open()

                IconPicker{
                    id:iconPicker
                    parent : root.pickerParent
                    onSelected:{
                        root.selectedIcon = currentIcon
                        root.iconPicked()
                    }
                }
            }

        }

        Loader{
            active: root.extraContent
            sourceComponent : root.extraContent
            Layout.fillWidth : root.extraContent_fillWidth
            Layout.fillHeight : true
            Layout.alignment : root.extraContent_horizontalAlignment
            //anchors.fill: extraContent
        }

    }


}
