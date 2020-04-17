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
import FontAwesome 1.0

ApplicationWindow {
    id: mainApp
    visible: true
    width: NavMan.windowWidth
    height: NavMan.windowHeight
    onWidthChanged:NavMan.windowWidth = width
    onHeightChanged: NavMan.windowHeight = height


    title: pm.currentSlideDeckPath.length > 0 ? qsTr("SwagSoftware (%1%2)").arg( pm.currentSlideDeckPath ).arg(pm.pendingChanges ? "*":"") : qsTr("Swag")

    Material.accent : pm.loaded ? pm.prezProperties.materialAccent : NavMan.settings.materialAccent
    Material.background : pm.loaded ? pm.prezProperties.materialBackground : NavMan.settings.materialBackground
    Material.elevation : pm.loaded ? pm.prezProperties.materialElevation : NavMan.settings.materialElevation
    Material.foreground : pm.loaded ? pm.prezProperties.materialForeground : NavMan.settings.materialForeground
    Material.primary : pm.loaded ? pm.prezProperties.materialPrimary : NavMan.settings.materialPrimary
    Material.theme : pm.loaded ? pm.prezProperties.materialTheme : NavMan.settings.materialTheme


    menuBar:MainMenu{}

    header:Header{
        id:toolBar
        onToggleMenu:leftMenu.visible ? leftMenu.close() : leftMenu.open()
    }

    LeftMenu{
        id:leftMenu
        width:Math.min(150, mainApp.contentItem.width * .3)
        height:mainApp.contentItem.height
        y:menuBar.height + toolBar.height
    }




    SplitView{
        x:leftMenu.position * leftMenu.width
        width:parent.width - x - elementToolBox.width
        height:parent.height

        Loader{
            SplitView.preferredWidth: parent.width / 4
            SplitView.minimumWidth: 100
            visible:active
            active:NavMan.editMode && NavMan.elementItemToModify
            sourceComponent:  ElementEditor{

                target : NavMan.elementItemToModify
            }
        }


        CodeRenderer{
            id:renderer

            SplitView.fillWidth: true
            height:parent.height



            showEditor:NavMan.showDocumentCode
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

    ToolBox{
        id:elementToolBox
        visible:NavMan.editMode && NavMan.currentSlide
        anchors.right: parent.right
    }



    Button{
        font.family : FontAwesome.fontFamily
        text:FontAwesome.save
        width:30;height:width
        visible:renderer.showEditor
        onClicked: {
            pm.writeDocument(pm.urlSlide(), renderer.code)
            pm.reload()
        }
    }

    footer:Footer{
        width:mainApp.width
        height:40
        visible:pm.loaded
    }
}

