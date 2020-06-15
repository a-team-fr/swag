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
import QtQuick.Controls.Material 2.2
//import SortFilterProxyModel 0.2
import MaterialIcons 1.0
import fr.ateam.swag 1.0
import Swag 1.0

Drawer {
    id: root

    ScrollView {
        anchors.fill: parent
        id:scroll
        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 5
            model: pm.lstSlides
            clip: true
            currentIndex : pm.slideSelected
            spacing: 5
            delegate: ItemDelegate {
                width: listView.width
                height: content.height
                highlighted: index === listView.currentIndex
                hoverEnabled: true
                Item {
                    id: content
                    width: parent.width
                    property int bottomPanel:30
                    height: (width / NavMan.windowWidth * NavMan.windowHeight) + bottomPanel

                    ShaderEffectSource {
                        sourceItem: Loader {
                            visible:false
                            source: pm.urlSlide(index)
                            transform:Scale{
                                xScale:width / NavMan.windowWidth
                                yScale:height / NavMan.windowHeight
                            }
                        }
                        width: parent.width
                        height: parent.height - parent.bottomPanel
                        live: true
                        hideSource: true
                    }

                    Label {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: visible ? parent.bottomPanel : 0
                        visible: !content.parent.hovered
                        text: modelData["title"]
                        elide: Text.ElideRight
                    }

                    Row {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: visible ? parent.bottomPanel : 0
                        spacing: 1
                        visible: content.parent.hovered

                        FAButton {
                            icon: MaterialIcons.keyboard_arrow_up
                            onClicked: pm.changeSlideOrder(index, index - 1)
                            enabled: index > 0
                            width: 30
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            hoverEnabled: true
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Move slide up")
                        }
                        FAButton {
                            icon: MaterialIcons.content_copy
                            width: 30
                            height: width
                            enabled: true
                            onClicked: {pm.cloneSlide(index);NavMan.saveCurrentSlideAndReload(true);}
                            anchors.verticalCenter: parent.verticalCenter
                            hoverEnabled: true
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("clone")
                        }
                        FAButton {
                            icon: MaterialIcons.edit
                            width: 30
                            height: width
                            enabled: true
                            onClicked: {
                                pm.editSlide(index)
                                root.close()
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            hoverEnabled: true
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("edit slide")
                        }
                        FAButton {
                            icon: MaterialIcons.keyboard_arrow_down
                            width: 30
                            height: width
                            enabled: index < (listView.count - 1)
                            onClicked: pm.changeSlideOrder(index, index + 1)
                            anchors.verticalCenter: parent.verticalCenter
                            hoverEnabled: true
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Move slide down")
                        }
                    }
                }

                onClicked: {
                    pm.selectSlide(index)
                    root.close()
                }
            }
        }
    }
}
