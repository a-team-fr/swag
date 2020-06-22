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
import MaterialIcons 1.0
import QtQuick.Dialogs 1.3
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


    //menuBar:MainMenu{}
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



    FileDialog{
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

    header:Header{
        id:toolBar
        menuOpen: leftMenu.visible
        onToggleMenu:leftMenu.visible ? leftMenu.close() : leftMenu.open()
    }

    LeftMenu{
        id:leftMenu
        width:60
        height:mainApp.contentItem.height
        y:toolBar.height
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
        x : leftMenu.width
        visible : pm.showNavigator && pm.isSlideDisplayed

    }




    SplitView{
        x:leftMenu.position * leftMenu.width +  (navigator.visible ? navigator.width : 0)
        width:parent.width - x //- elementToolBox.width
        height:parent.height

        Pane{
            SplitView.fillWidth: true
            height:parent.height
            padding : (pm.editMode && NavMan.currentSlide) ? 30 : 0
            background:Rectangle{
                color:(pm.editMode && NavMan.currentSlide) ? "#888888" : "transparent"
            }
            Rectangle{
                id:page
                anchors.fill:parent
                border.width:1
                border.color:"black"
                color:"transparent"

                CodeRenderer{
                    id:renderer

                    anchors.fill:parent
                    SplitView.fillWidth: true
                    height:parent.height


                    showEditor:pm.showDocumentCode
                    style : NavMan.settings.defaultSyntaxHighlightingStyle
                    code : pm.readSlideQMLCode( pm.slideSelected)
                    rendererSource : pm.displayUrl
                    renderCode : false

                    onWidthChanged:NavMan.slideWidth = width
                    onHeightChanged:NavMan.slideHeight = height

                    onRenderedItemChanged:{
                        if (pm.prezProperties.displayMode!=="Loader") return;
                        NavMan.currentDocument = renderedItem
                    }

                }

            }
            DropShadow{
                anchors.fill: parent
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: page
            }
            Row{
                height:25
                width:parent.width
                anchors.top:parent.bottom
                visible : pm.editMode && NavMan.currentSlide
                FAButton{
                    height:parent.height
                    width:height
                    icon : MaterialIcons.add
                    onClicked :pm.createSlide()
                    rounded : true
                    decorate:false
                }
                FAButton {
                    height:parent.height
                    width:height
                    icon: MaterialIcons.settings
                    onClicked: pm.editSlide(pm.slideSelected)
                    decorate:false
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
            visible:active
            active:pm.editMode && NavMan.currentSlide
            sourceComponent: NavMan.elementItemToModify ? propertyPane : elementToolBox//ElementEditor{ target :  NavMan.elementItemToModify }
        }

    }
    Component{
        id:propertyPane
        ElementEditor{
            target :  NavMan.elementItemToModify
        }
    }

    Component{
        id:elementToolBox
        ToolBox{
        //    visible:pm.editMode && NavMan.currentSlide
        //    anchors.right: parent.right
        }
    }



    FAButton{
        icon:MaterialIcons.save
        width:30;height:width
        visible:renderer.showEditor
        onClicked: {
            pm.writeDocument(pm.urlSlide(), renderer.code)
            pm.reload()
        }
    }

    FileTransfertView{
        anchors.right:parent.right
        anchors.bottom:parent.bottom
    }

    footer:Footer{
        width:mainApp.width
        height:40
        //visible:pm.loaded && pm.isSlideDisplayed
    }



}

