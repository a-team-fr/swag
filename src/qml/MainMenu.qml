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

import Qt.labs.platform 1.1

MenuBar {
    id: menuBar

    signal newDocument();
    signal openDocument();


    Menu {
        title: qsTr("File")
        MenuItem {
            text: qsTr("New")
            onTriggered: menuBar.newDocument()
            enabled :  !pm.net.following
            shortcut:"Ctrl+N"
        }
        MenuItem {
            text: qsTr("Open")
            enabled :  !pm.net.following
            onTriggered: menuBar.openDocument()
            shortcut:"Ctrl+O"
        }

        /*MenuItem {
            text: qsTr("Save current slide")
            onTriggered: NavMan.saveCurrentSlide()//pm.saveToDisk()
        }*/
        MenuItem {
            text: qsTr("Save")
            onTriggered: NavMan.actionSave()
            enabled:pm.loaded &&  !pm.net.following

            shortcut:"Ctrl+S"

        }
        MenuItem {
            text: qsTr("Close")
            onTriggered: pm.unload()
            enabled:pm.loaded &&  !pm.net.following
            shortcut:"Ctrl+W"
        }
        MenuItem {
            text: qsTr("Quit")
            role:MenuItem.QuitRole
            onTriggered: Qt.quit()
            shortcut:"Ctrl+Q"
        }
    }
    Menu {
        title: qsTr("Edit")
        MenuItem {
            text: qsTr("New slide")
            onTriggered: pm.createSlide()
            enabled:pm.loaded &&  !pm.net.following
            shortcut:"Ctrl+Shift+N"
        }
        MenuItem {
            text: qsTr("PrintPdf")
            onTriggered:pm.displayType = PM.SlideExport
            enabled:pm.loaded &&  !pm.net.following
        }
        MenuItem {
            text: qsTr("Edit mode")
            onTriggered:pm.editMode = !pm.editMode
            checkable: true
            checked: pm.editMode
            enabled:pm.loaded &&  !pm.net.following
            shortcut:"Ctrl+E"
        }
        MenuItem {
            text: qsTr("Edit deck world")
            onTriggered: pm.viewWorldMode = !pm.viewWorldMode
            enabled:pm.loaded && (pm.displayType == PM.Slide_FlatView) &&  !pm.net.following
            checkable: true
            checked: pm.viewWorldMode
            shortcut:"Ctrl+D"
        }
        MenuItem {
            text: qsTr("Show code")
            onTriggered: pm.showDocumentCode = !pm.showDocumentCode
            checkable: true
            checked: pm.showDocumentCode
            enabled:pm.loaded
            shortcut:"Ctrl+T"
        }
    }
    Menu {
        title: qsTr("View")
        MenuItem {
            //role:MenuItem.PreferencesRole
            text: qsTr("Settings")
            onTriggered: pm.displayType = PM.GlobalSettings
        }
        MenuItem {
            text: qsTr("Deck settings")
            enabled: pm.loaded &&  !pm.net.following
            onTriggered: pm.displayType = PM.PrezSettings
        }
        MenuItem {
            text: qsTr("Slide settings")
            enabled: pm.loaded && pm.lstSlides.length &&  !pm.net.following
            onTriggered: pm.displayType = PM.SlideSettings
        }
        MenuItem {
            text: qsTr("Message")
            onTriggered: pm.displayType = PM.NetworkingTest
            shortcut:"Ctrl+M"
        }

    }
    Menu {
        title: qsTr("?")
        MenuItem {
            role:MenuItem.AboutRole
            text: qsTr("About s🤘ag")
            onTriggered: pm.displayType = PM.About
        }
    }

}
