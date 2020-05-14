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
//import Qt.labs.folderlistmodel 2.2
//import QSyncable 1.0
import Qt.labs.settings 1.0
import fr.ateam.swag 1.0
import QtQuick.Controls.Material 2.14
pragma Singleton

Item {
    id:root

    property int windowWidth : 640
    property int windowHeight : 480
    property int slideWidth : 640
    property int slideHeight : 480


    property var settings : Settings{
        property bool openLastPrezAtStartup : false
        property bool loadElement3d: false //Qt.platform.os !== "windows" || Qt.platform.os === "osx" )
        property string defaultSyntaxHighlightingStyle : "default"
        property alias windowWidth : root.windowWidth
        property alias windowHeight : root.windowHeight

        property string swagBackend : "https://swagsoftware.net/"
        property string profileAuthor : ""
        property bool signinAtStartup : true

        property color materialAccent : "#f48fb1"
        property color materialBackground : "#303030"
        property int materialElevation : 6
        property color materialForeground : "#ffffff"
        property color materialPrimary : "#3f51b5"
        property int materialTheme :  Material.Dark
    }

    property var currentDocument : null //the object is either a slide, or prezSettings or slideSettings...
        //onCurrentDocumentChanged: console.log("currentDocument:"+currentDocument)
    readonly property var currentSlide : pm.isSlideDisplayed ? currentDocument : null
        //onCurrentSlideChanged: console.log("currentSlide:"+currentSlide)

    signal sigPrevious(bool ForcetoSlide);
    signal sigNext(bool ForcetoSlide);
    signal navigationFocusChanged(var item );

    //signal rebuildNavigationFocusList( );
    //signal triggerElementPositionner(var element); //root is to be an Element item

    property bool navigationManagedBySlide : (pm.displayType === PM.Slide_FlatView)

    property var elementItemToPosition : null
    property var elementItemToModify : null


    function actionSave()
    {
        if (currentSlide )
            currentSlide.saveDocument( );

        pm.saveToDisk()
    }


    function actionReloadSlide(reloadIfNeeded)
    {
        if (currentSlide )
        {
            currentSlide.saveDocument( );
            if (reloadIfNeeded)
                pm.reload();
        }
    }

    function actionNext(ForcetoSlide)
    {
        if (pm.pendingChanges)
            actionSave();

        if (root.navigationManagedBySlide)
            sigNext(ForcetoSlide)
        else pm.nextSlide();
    }

    function actionPrevious(ForcetoSlide)
    {
        if (pm.pendingChanges)
            actionSave();

        if (root.navigationManagedBySlide)
            sigPrevious(ForcetoSlide)
        else pm.previousSlide();
    }

    function actionCancel()
    {
        elementItemToPosition = null;
        elementItemToPosition = null;
        pm.displayType = PM.Slide;
        pm.showDocumentCode =false;
        pm.editMode = false;
        pm.viewWorldMode = false;

    }

    function displayEditElement(item){
        NavMan.elementItemToModify = item
    }

    Shortcut {
        sequence: StandardKey.MoveToPreviousChar
        context: Qt.ApplicationShortcut
        onActivated: actionPrevious(false)
    }
    Shortcut {
        sequence: StandardKey.MoveToNextChar
        context: Qt.ApplicationShortcut
        onActivated: actionNext(false)
    }
    Shortcut {
        sequence: StandardKey.Cancel
        context: Qt.ApplicationShortcut
        onActivated: actionCancel()
    }

    Shortcut {
        sequence: "Ctrl+D"
        context: Qt.ApplicationShortcut
        onActivated: pm.viewWorldMode = !pm.viewWorldMode
    }

    Shortcut {
        sequence: "Ctrl+E"
        context: Qt.ApplicationShortcut
        onActivated: pm.editMode = !pm.editMode
    }
    Shortcut {
        sequence: "Ctrl+R"
        context: Qt.ApplicationShortcut
        onActivated: pm.reload(true);
    }
    Shortcut {
        sequence: "Ctrl+S"
        context: Qt.ApplicationShortcut
        onActivated: actionSave()
    }
    Shortcut {
        sequence: "Ctrl+T"
        context: Qt.ApplicationShortcut
        onActivated: pm.showDocumentCode = !pm.showDocumentCode
    }

    Shortcut {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }

    Shortcut {
        sequence: StandardKey.Close
        context: Qt.ApplicationShortcut
        onActivated: pm.unload()
    }


    /*------------------------------------------------------------------------------------------
                kinda output (usefull properties with readonly binding)
    ------------------------------------------------------------------------------------------*/
    //readonly property string idAliasRoleName : "fileName"









}




