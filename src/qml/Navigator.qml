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
//import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.2
import MaterialIcons 1.0
import fr.ateam.swag 1.0
import Swag 1.0


Popup {
    id: root
    closePolicy: Popup.NoAutoClose

    Connections{
        target:pm
        function onSlidePageRatioChanged(){
            scroll.forceRedrawNumber = scroll.forceRedrawNumber+1;
        }
    }

    ScrollView {
        id:scroll
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        contentHeight : listView.childrenRect.height
        clip : true

        property int forceRedrawNumber : 0
        function getSlideUrl( slideIdx, forceRedrawNumber){
            return pm.urlSlide( slideIdx );
        }
        function getPageRatio(slideIdx, forceRedrawNumber){
            return pm.slidePageRatio(slideIdx)
        }

        ListView{
            id: listView
            anchors.fill: parent

            property int bottomPanel:30
            property bool dragInProgress : false
            property int offsetDropArea : dragInProgress ? 50 : 0
            property int spacing: 5

            clip: true
            model: pm.lstSlides.length
            currentIndex: pm.slideSelected

            delegate: Item {
                id: content
                z : dragActive ? 1 : 0
                width: listView.width
                property int thumbHeight :  width / scroll.getPageRatio(index, scroll.forceRedrawNumber) + listView.bottomPanel
                property int offsetAddSlideArea : index === (listView.count - 1) ? 50 : 0
                height: thumbHeight + (dragActive ? 0 : listView.offsetDropArea) + offsetAddSlideArea
                property alias hovered : contentMA.containsMouse

                Drag.active: contentMA.drag.active
                Drag.dragType : Drag.Automatic //Drag.Automatic
                Drag.supportedActions : Qt.MoveAction //Qt.CopyAction
                Drag.mimeData: { "text/plain": index }
                property bool dragActive : Drag.active
                onDragActiveChanged: {

                    listView.dragInProgress = dragActive
                    parent : dragActive ? scroll : listView
                }


                MouseArea{
                    id:contentMA
                    anchors.fill: parent
                    hoverEnabled: true

                    propagateComposedEvents:true
                    preventStealing: true

                    drag.axis : Drag.YAxis
                    drag.target:content
                    drag.filterChildren: true

                    onClicked: pm.selectSlide(index)

                }

                Column{
                    anchors.fill:parent

                    Rectangle{
                        width: parent.width
                        height: content.thumbHeight - listView.bottomPanel
                        color : content.ListView.isCurrentItem  ? Material.accent : "white"
                        ShaderEffectSource {
                            anchors.fill:parent
                            anchors.margins: 3 //'colored border to show currently selected slide
                            sourceItem: Loader {
                                visible:false
                                width:NavMan.slideWidth
                                height:NavMan.slideHeight
                                source: scroll.getSlideUrl(index, scroll.forceRedrawNumber)
                            }
                            live: true
                            hideSource: false
                        }

                    }

                    Label {
                        width: parent.width
                        height: visible ? listView.bottomPanel : 0
                        visible: !content.hovered
                        text: pm.lstSlides[index].title
                        elide: Text.ElideRight
                    }

                    Row {
                            width: parent.width
                            height: visible ? listView.bottomPanel : 0
                            spacing: 1
                            visible: content.hovered

                            FAButton {
                                icon: MaterialIcons.keyboard_arrow_up
                                onClicked: pm.changeSlideOrder(index, index - 1)
                                enabled: index > 0
                                width: 30
                                height: width
                                anchors.verticalCenter: parent.verticalCenter
                                hoverEnabled: false
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
                                hoverEnabled: false
                                ToolTip.visible: hovered
                                ToolTip.text: qsTr("clone")
                            }
                            FAButton {
                                icon: MaterialIcons.settings
                                width: 30
                                height: width
                                enabled: true
                                onClicked: {
                                    pm.editSlideSettings(index)
                                    root.close()
                                }
                                anchors.verticalCenter: parent.verticalCenter
                                hoverEnabled: false
                                ToolTip.visible: hovered
                                ToolTip.text: qsTr("Slide settings")
                            }
                            FAButton {
                                icon: MaterialIcons.keyboard_arrow_down
                                width: 30
                                height: width
                                enabled: index < (listView.count - 1)
                                onClicked: pm.changeSlideOrder(index, index + 1)
                                anchors.verticalCenter: parent.verticalCenter
                                hoverEnabled: false
                                ToolTip.visible: hovered
                                ToolTip.text: qsTr("Move slide down")
                            }

                        }

                    DropArea{
                        id:dropArea
                        anchors.horizontalCenter : parent.horizontalCenter
                        height:dragActive ? 0 : listView.offsetDropArea
                        width:height
                        keys: ["text/plain"]
                        onDropped: {
                            if (drop.hasText) {
                                pm.changeSlideOrder(drop.text, index)
                                scroll.forceRedrawNumber = scroll.forceRedrawNumber+1;
                                drop.accept(drop.proposedAction)
                            }
                        }

                        Rectangle{
                            anchors.fill: parent
                            border.width: 1
                            border.color :parent.containsDrag ? "green" : "yellow"
                            color:"transparent"

                        }
                    }

                    FAButton{
                        anchors.horizontalCenter : parent.horizontalCenter
                        height:content.offsetAddSlideArea
                        visible : height > 0
                        width:height
                        icon : MaterialIcons.add
                        onClicked :pm.createSlide()
                        rounded : true
                    }
                }
            }

        }
    }
}

