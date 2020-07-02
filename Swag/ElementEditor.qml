
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
    signal done

    Flickable {
        contentHeight: content.childrenRect.height + 50
        anchors.fill : parent
        anchors.bottomMargin: footer.height
        anchors.margins: 1
        clip:true

        Column{
            id:content
            width : parent.width
            spacing : 2
            /////////////////////////////////////////////////////////////
            //////////////////////// Element properties /////////////////
            Loader {
                width: parent.width
                active : target
                property var target : root.target
                sourceComponent: Component{
                    Column{
                        width:parent.width
                        spacing : 2
                        visible:target
                        FormItem{
                            title: qsTr("Id")
                            width: parent.width
                            text: target.idAsAString
                            onEditingFinished: {
                                //TODO : check unicity of id among slide elements
                                //TODO : enforce naming policy
                                target.idAsAString = text
                                //save & reload right away to get a proper id
                                NavMan.actionReloadSlide(true);
                            }
                            showButton:true
                            onConfirmed: {
                                target.idAsAString = text
                                //save & reload right away to get a proper id
                                NavMan.actionReloadSlide(true);
                            }
                        }
                        RowLayout{
                            width: parent.width
                            FormItem{
                                title: qsTr("x")
                                Layout.fillWidth: true
                                text: target.x.toFixed(0)
                                onEditingFinished: target.setX( Number(text) )
                                textField.validator: IntValidator{}
                            }
                            FormItem{
                                title: qsTr("y")
                                Layout.fillWidth: true
                                text: target.y.toFixed(0)
                                onEditingFinished: target.setX( Number(text) )
                                textField.validator: IntValidator{}
                            }
                            FormItem{
                                title: qsTr("z")
                                Layout.fillWidth: true
                                text: target.z.toFixed(0)
                                onEditingFinished: target.z = Number(text)
                                textField.validator: IntValidator{}
                            }
                        }

                        RowLayout{
                            width: parent.width


                            FormItem{
                                title: qsTr("width")
                                Layout.fillWidth: true
                                text: target.width.toFixed(0)
                                onEditingFinished: target.setWidth( Number(text) )
                                textField.validator: IntValidator{}
                            }
                            FormItem{
                                title: qsTr("height")
                                Layout.fillWidth: true
                                text: target.height.toFixed(0)
                                onEditingFinished: target.setHeight( Number(text) )
                                textField.validator: IntValidator{}
                            }


                            FormItem{
                                title: qsTr("rotation")
                                Layout.fillWidth: true
                                text: target ? target.rotation.toFixed(1) : 0
                                onEditingFinished: target.rotation = Number(text)
                                textField.validator: DoubleValidator{}
                            }
                        }

                        //DEACTIVATED FOR NOW
                        //            SwitchDelegate {
                        //                width: parent.width
                        //                text:qsTr("navigationFocus")
                        //                checked: target ? target.navigationFocus : false
                        //                onToggled: target.navigationFocus = checked
                        //            }

                    }
                }
            }


            ToolSeparator{ orientation: Qt.Horizontal; width: parent.width; anchors.horizontalCenter : parent.horizontalCenter}

            /////////////////////////////////////////////////////////////
            //////////////////////// Custom properties /////////////////
            Loader {
                width: parent.width
                active : root.target
                property var target : root.target
                sourceComponent: root.target ? root.target.editorComponent : null
            }
        }
    }

    RowLayout{
        id:footer
        width:parent.width
        height : childrenRect.height
        anchors.bottom: parent.bottom
        spacing : 3

        FAButton{
            //decorate:false
            icon:MaterialIcons.crop
            ToolTip.text: qsTr("Resize and reposition")
            ToolTip.visible : hovered
            onClicked: NavMan.elementItemToPosition = target

        }

        FAButton{
            //decorate:false
            icon:MaterialIcons.save
            ToolTip.text: qsTr("save slide")
            ToolTip.visible : hovered
            onClicked: NavMan.actionSaveSlide()
        }

        FAButton{
            icon:MaterialIcons.remove
            color:"red"
            ToolTip.text: qsTr("Remove element")
            ToolTip.visible : hovered
            onClicked: {
                target.destroy()
                NavMan.actionReloadSlide(false);
            }

        }
    }




}
