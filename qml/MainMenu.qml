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
import fr.ateam.swag 1.0
import QtQuick.Dialogs 1.3

MenuBar {
    id: menuBar

    FileDialog{
        id: fileDialog
        folder:pm.defaultPrezPath()
        property string fileAction :""
        selectFolder: true
        onAccepted: {
            if (fileAction == "Open")
                pm.load( fileUrl )
            else if (fileAction == "New")
            pm.create( fileUrl )
        }
    }

    Shortcut {
        sequence: StandardKey.Open
        context: Qt.ApplicationShortcut
        onActivated: {
            fileDialog.fileAction = "Open";
            fileDialog.open();
        }
    }



    Menu {
        title: qsTr("File")
        MenuItem {
            text: qsTr("New")
            onTriggered: {
                fileDialog.fileAction = "New";
                fileDialog.open();
            }
        }
        MenuItem {
            text: qsTr("Open")
            onTriggered: {
                fileDialog.fileAction = "Open";
                fileDialog.open();
            }
        }

        /*MenuItem {
            text: qsTr("Save current slide")
            onTriggered: NavMan.saveCurrentSlide()//pm.saveToDisk()
        }*/
        MenuItem {
            text: qsTr("Save (Ctrl+S)")
            onTriggered: NavMan.actionSave()
            enabled:pm.loaded
        }
        MenuItem {
            text: qsTr("Close")
            onTriggered: pm.unload()
            enabled:pm.loaded
        }
        MenuItem {
            text: qsTr("Quit")
            onTriggered: Qt.quit()
        }
    }
    Menu {
        title: qsTr("Edit")
        MenuItem {
            text: qsTr("New slide")
            onTriggered: pm.createSlide()
            enabled:pm.loaded
        }
        MenuItem {
            text: qsTr("PrintPdf")
            onTriggered:pm.displayType = PM.SlideExport
            enabled:pm.loaded
        }
        MenuItem {
            text: qsTr("Edit mode (Ctrl+E)")
            onTriggered: NavMan.actionEditMode()
            checkable: true
            checked: NavMan.editMode
            enabled:pm.loaded
        }
        MenuItem {
            text: qsTr("Edit deck world (Ctrl+D)")
            onTriggered: NavMan.actionviewWorldMode()
            enabled:pm.loaded && (pm.displayType == PM.Slide_FlatView)
            checkable: true
            checked: NavMan.viewWorldMode
        }
        MenuItem {
            text: qsTr("Show code (Ctrl+T)")
            onTriggered: NavMan.showDocumentCode = !NavMan.showDocumentCode
            checkable: true
            checked: NavMan.showDocumentCode
            enabled:pm.loaded
        }
    }
    Menu {
        title: qsTr("View")
        MenuItem {
            text: qsTr("Settings")
            onTriggered: pm.displayType = PM.GlobalSettings
        }
        MenuItem {
            text: qsTr("Deck settings")
            enabled: pm.loaded
            onTriggered: pm.displayType = PM.PrezSettings
        }
        MenuItem {
            text: qsTr("Slide settings")
            enabled: pm.loaded && pm.lstSlides.length
            onTriggered: pm.displayType = PM.SlideSettings
        }
    }
    Menu {
        title: qsTr("?")
        MenuItem {
            text: qsTr("About s🤘ag")
            onTriggered: pm.displayType = PM.About
        }
    }

}
