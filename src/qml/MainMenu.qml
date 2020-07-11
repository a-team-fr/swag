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
        MenuItem {
            text: qsTr("PrintPdf")
            onTriggered:pm.displayType = PM.SlideExport
            enabled:pm.loaded &&  !pm.net.following
        }
        MenuItem {
            text: qsTr("Save")
            onTriggered: pm.saveSwag()
            enabled:pm.loaded &&  !pm.net.following

            shortcut:"Ctrl+S"

        }
        MenuItem {
            text: qsTr("Close")
            onTriggered: pm.closeSwag()
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
        title: qsTr("View")
        MenuItem {
            text: qsTr("Edit mode")
            onTriggered:pm.editMode = !pm.editMode
            checkable: true
            checked: pm.editMode
            enabled:pm.loaded &&  !pm.net.following
            shortcut:"Ctrl+E"
        }
        MenuItem {
            role:MenuItem.PreferencesRole
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
