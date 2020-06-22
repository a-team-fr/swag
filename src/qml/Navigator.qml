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
//import QtQuick.Controls.Material 2.2
import MaterialIcons 1.0
import fr.ateam.swag 1.0
import Swag 1.0


Popup {
    id: root
    closePolicy: Popup.NoAutoClose

    ScrollView {
        id:scroll
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        //contentWidth:width
        contentHeight : listView.childrenRect.height //listView.count * (listView.thumbHeight + listView.spacing)
        clip : true

        property int forceRedrawNumber : 0
        function getSlideUrl( slideIdx, forceRedrawNumber){
            return pm.urlSlide( slideIdx );
        }

        ListView{
            id: listView
            width : root.width
            height : root.height
            property int thumbHeight :  (width / NavMan.windowWidth * NavMan.windowHeight) + bottomPanel
            property int bottomPanel:30
            property bool dragInProgress : false
            property int offsetDropArea : dragInProgress ? 50 : 0
            property int spacing: 5

            clip: true
            anchors.fill: parent
            model: pm.lstSlides.length

            delegate: Item {
                id: content
                z : dragActive ? 1 : 0
                width: listView.width
                height: listView.thumbHeight + (dragActive ? 0 : listView.offsetDropArea)
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

                    ShaderEffectSource {
                        sourceItem: Loader {
                            visible:false
                            source: scroll.getSlideUrl(index, scroll.forceRedrawNumber)
                            transform:Scale{
                                xScale:width / NavMan.windowWidth
                                yScale:height / NavMan.windowHeight
                            }
                        }
                        width: parent.width
                        height: listView.thumbHeight - listView.bottomPanel
                        live: true
                        hideSource: true
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
                                    pm.editSlide(index)
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
                        onDropped: if (drop.hasText) {
                            //if (drop.proposedAction == Qt.MoveAction || drop.proposedAction == Qt.CopyAction) {

                                console.log("Move " + drop.text + " to " + index);
                                pm.changeSlideOrder(drop.text, index)
                                scroll.forceRedrawNumber = scroll.forceRedrawNumber+1;
                                       drop.accept(drop.proposedAction)

                            //}
                        }

                        Rectangle{
                            anchors.fill: parent
                            border.width: 1
                            border.color :parent.containsDrag ? "green" : "yellow"
                            color:"transparent"

                        }
                    }
                }
            }

        }
    }
}

