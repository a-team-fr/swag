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
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Controls.Material 2.14
import fr.ateam.swag 1.0
import Swag 1.0
import MaterialIcons 1.0
import QtQuick.Dialogs 1.3 as QQD
import QtGraphicalEffects 1.12


ApplicationWindow {
    id: mainApp
    visible: true
    width: NavMan.windowWidth
    height: NavMan.windowHeight
    onWidthChanged:NavMan.windowWidth = width
    onHeightChanged: NavMan.windowHeight = height


    title: pm.currentSlideDeckPath.length > 0 ? qsTr("SwagSoftware (%1%2)").arg( pm.currentSlideDeckPath ).arg(pm.pendingChanges ? "*":"") : qsTr("Swag")

    Material.accent : NavMan.settings.materialAccent//pm.loaded ? pm.prezProperties.materialAccent : NavMan.settings.materialAccent
    Material.background : NavMan.settings.materialBackground // pm.loaded ? pm.prezProperties.materialBackground : NavMan.settings.materialBackground
    Material.elevation : NavMan.settings.materialElevation//pm.loaded ? pm.prezProperties.materialElevation : NavMan.settings.materialElevation
    Material.foreground : NavMan.settings.materialForeground//pm.loaded ? pm.prezProperties.materialForeground : NavMan.settings.materialForeground
    Material.primary : NavMan.settings.materialPrimary//pm.loaded ? pm.prezProperties.materialPrimary : NavMan.settings.materialPrimary
    Material.theme : NavMan.settings.materialTheme//pm.loaded ? pm.prezProperties.materialTheme : NavMan.settings.materialTheme

    MainMenu{
        onOpenDocument:{
            fileDialog.fileAction = "Open";
            fileDialog.open();
        }
        onNewDocument:{
            fileDialog.fileAction = "New";
            fileDialog.open();
        }
    }

    QQD.FileDialog{
        id: fileDialog
        visible: false
        nameFilters: [ "Swag document (*.swag)" ]
        defaultSuffix:"swag"
        selectExisting: fileAction == "Open"
        title:fileAction=="Open" ? qsTr("Open a swag document")  : qsTr("Select a new Swag document name")
        property string fileAction :""
        folder:pm.slideDecksFolderPath

        onAccepted: {
            if (fileAction == "Open")
                pm.load( fileUrl )
            else if (fileAction == "New")
                pm.create( fileUrl )
        }
    }

    LeftMenu{
        id:leftMenu
        width:60
        height:mainApp.contentItem.height
        onOpenDocument:{
            fileDialog.fileAction = "Open";
            fileDialog.open();
        }
        onNewDocument:{
            fileDialog.fileAction = "New";
            fileDialog.open();
        }
    }

    Navigator{
        id:navigator
        width:Math.min(150, mainApp.contentItem.width * .3)
        height:mainApp.contentItem.height
        x : leftMenu.visible ? leftMenu.width : 0
        visible : pm.showNavigator && pm.isSlideDisplayed

    }

    Item{

        x:leftMenu.position * leftMenu.width +  (navigator.visible ? navigator.width : 0)
        width:parent.width - x //- elementToolBox.width
        height:parent.height
        property double pageRatio : pm.slidePageRatio( pm.slideSelected)
        property int usableWidth : pm.editMode ? width * 0.75  - margins : width - margins
        property int margins : 40
        property int usableHeight : height - margins
        property int virtualPageWidth : Math.max( 30, Math.min( usableWidth, height * pageRatio) )
        property int virtualPageHeight : Math.max( 30, virtualPageWidth / pageRatio )

        onVirtualPageWidthChanged: NavMan.slideWidth = virtualPageWidth
        onVirtualPageHeightChanged: NavMan.slideHeight = virtualPageHeight


        //Normal view
        Loader{
            width: pm.isSlideDisplayed ? NavMan.slideWidth : parent.width
            height : pm.isSlideDisplayed ? NavMan.slideHeight : parent.height
            anchors.centerIn : parent
            visible : !renderer.visible
            active : visible
            source : pm.displayUrl
            onItemChanged: if (visible) NavMan.currentDocument = item

        }

        CodeRenderer{
            id:renderer
            anchors.fill:parent
            visible : pm.editMode && pm.isSlideDisplayed
            showEditor: pm.showDocumentCode
            style : NavMan.settings.defaultSyntaxHighlightingStyle
            code : pm.readSlideQMLCode( pm.slideSelected)
            rendererComponent : editModeView
            renderCode : false
            showSaveButton: true
            onSaveButtonClicked: {
                pm.writeSlideDocument(renderer.code)
                renderer.rendererComponent = null

                pm.reload()
                renderer.rendererComponent = editModeView
            }
        }

        Component{
            id:editModeView
            SplitView{
                Rectangle{
                    id:world
                    SplitView.fillWidth: true
                    height:parent.height
                    color: "#888888"
                    //property bool slideEditing : pm.editMode//(pm.editMode && pm.isSlideDisplayed)
                    //onSlideEditingChanged: fitToPage()
                    //Component.onCompleted: fitToPage()
                    function fitToPage()
                    {
                        //incorrect geometry
                        if (world.height === 0 || page.height === 0 || world.width === 0 ||  page.width === 0 )
                        {
                            console.log("incorrect geometry : "+world.width + "-" + page.width + "-" +world.height + "-" + page.height)
                            return false;
                        }

                        var margin = 20;
                        // compute scale to adjust page and a margin
                        page.scale = Math.min( world.height / (page.height + margin), world.width / (page.width + margin));
                        // compute flickable content origin to center page
                        flickable.contentX = -0.5*(width - page.width)
                        flickable.contentY = -0.5*(height - page.height)

                        return true;
                    }

                    PinchArea{
                        id:pincharea
                        anchors.fill:parent
                        pinch{
                            target: page
                            minimumScale: 0.01 ; maximumScale: 5
                            dragAxis: Pinch.XAndYAxis
                        }

                    }

                    Flickable{
                        id:flickable
                        width:world.width; height:world.height
                        contentHeight : page.height; contentWidth : page.width + 1 // for some reason +1 is required to get horizontal flicking
                        clip:true
                        topMargin: page.height * page.scale
                        bottomMargin: page.height * page.scale
                        rightMargin: page.width * page.scale
                        leftMargin: page.width * page.scale
                        Rectangle{
                            id:page
                            width : world.width
                            height: width / pm.slidePageRatio( pm.slideSelected )//NavMan.slideHeight

                            border.width:1
                            border.color:"black"
                            color:"white"

                            layer.enabled:true
                            layer.effect : DropShadow{
                                horizontalOffset: 8
                                verticalOffset: 8
                                radius: 8.0
                                samples: 17
                            }

                            Loader{
                                anchors.fill:parent
                                source : pm.displayUrl
                                onSourceChanged: {
                                    if (pm.prezProperties.displayMode!=="Loader") return;
                                    NavMan.currentDocument = item
                                }
                            }


                        }

                    }

                    MouseArea
                    {
                        anchors.fill : parent
                        //Have the wheel to zoom (i.o pan) within the flickable
                        acceptedButtons : Qt.MiddleButton
                        scrollGestureEnabled : false
                        onWheel:{
                            page.scale += ( wheel.angleDelta.y / 360 * 0.1 * 1) //TODO : add settings for scroll sensitivity and invert factor
                            page.scale = Math.max ( Math.min ( page.scale, pincharea.pinch.maximumScale), pincharea.pinch.minimumScale)
                        }
                        //trigger fit to page on wheel button click
                        onClicked : world.fitToPage()



                    }


                    RowLayout{
                        height:50
                        width:parent.width
                        anchors.bottom : parent.bottom
                        Row{
                            height:parent.height
                            Layout.alignment : Qt.AlignLeft
                            FAButton{
                                height:parent.height
                                width:height
                                icon : MaterialIcons.add
                                iconColor: NavMan.settings.materialAccent
                                onClicked :pm.createSlide()
                                rounded : true
                                decorate:false
                            }
                            FAButton {
                                height:parent.height
                                width:height
                                icon: MaterialIcons.settings
                                iconColor: NavMan.settings.materialAccent
                                onClicked: pm.editSlide(pm.slideSelected)
                                decorate:false
                            }
                            FAButton {
                                height:parent.height
                                width:height
                                ToolTip.text: qsTr("Show code")
                                onClicked: pm.showDocumentCode = !pm.showDocumentCode
                                icon: MaterialIcons.bug_report
                                iconColor: checked ? Qt.darker(NavMan.settings.materialAccent) : NavMan.settings.materialAccent
                                checked: pm.showDocumentCode
                                decorate:false
                            }
                        }
                        Row{
                            height:parent.height
                            Layout.alignment : Qt.AlignRight
                            Slider{
                                value : page.scale
                                from : 0.002//pincharea.pinch.minimumScale
                                to : 5//pincharea.pinch.maximumScale
                                onMoved:page.scale = value
                            }
                            FAButton {
                                height:parent.height
                                width:height
                                icon: MaterialIcons.settings_overscan
                                iconColor: NavMan.settings.materialAccent
                                onClicked: world.fitToPage()
                                decorate:false
                            }
                        }
                        //                FAButton{
                        //                    icon:MaterialIcons.remove
                        //                    iconColor:"red"
                        //                    text:qsTr("Delete slide")
                        //                    onClicked: pm.removeSlide();
                        //                }

                    }


                }



                Loader{
                    SplitView.preferredWidth: parent.width / 4
                    SplitView.minimumWidth: 100
                    sourceComponent: NavMan.elementItemToModify ? propertyPane : elementToolBox//ElementEditor{ target :  NavMan.elementItemToModify }
                    Component{
                        id:propertyPane
                        ElementEditor{
                            target :  NavMan.elementItemToModify
                            z:100
                        }
                    }
                    Component{
                        id:elementToolBox
                        ToolBox{}
                    }
                }

            }

        }

    }

    Dialog{
        id:modalQuery
        x: 0.5*(mainApp.width - width); y : 0.5*(mainApp.height - height)
        closePolicy : Popup.NoAutoClose
        standardButtons: Dialog.Yes | Dialog.No
        title:"Big question"
        modal: true

        property string contentText : "Are you in a good mood today ?"

        Label{
            anchors.fill:parent
            text : modalQuery.contentText
        }

        Connections{
            target:pm.modalQuery
            function onModalQueryStart(titleText, contentText, buttons){
                modalQuery.title = titleText;
                modalQuery.contentText = contentText;
                modalQuery.standardButtons = buttons;
                modalQuery.open();
            }
        }
        onAccepted: pm.modalQuery.modalQueryResponse(result)
        onRejected: pm.modalQuery.modalQueryResponse(result)

    }


    FileTransfertView{
        anchors.right:parent.right
        anchors.bottom:parent.bottom
    }

    footer:Footer{
        width:mainApp.width
        height:40
        visible:pm.loaded && pm.isSlideDisplayed

        menuToToggle: leftMenu
        onToggleMenu: leftMenu.visible ? leftMenu.close() : leftMenu.open()
    }



}

