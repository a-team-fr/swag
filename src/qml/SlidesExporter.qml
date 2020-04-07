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



Frame {
    id: root
    property int currentSlideIdx : 0
    property var lstUrls :pm.urlSlides()
    property bool exportRunning : false;
    property int msWaitDelayBeforeExport :1000
    property bool autoStart : true


    readonly property url slideUrl : lstUrls[currentSlideIdx]
    readonly property int nbSlides : lstUrls.length

    onSlideUrlChanged: console.log(slideUrl)

    Component.onCompleted: { if (root.autoStart) startExport();}


    Connections{
        target:pm
        onSlideExported:{
            if (root.currentSlideIdx < (root.nbSlides-1))
                root.currentSlideIdx++;
            else root.stopExport()
        }
    }

    function startExport(){
        exportRunning = true
        pm.startPDFExport()
        //pm.addSlidePDFExport( loader.item)
        delaySlideExport.restart()
    }
    function stopExport(){
        pm.endPDFExport();
        exportRunning = false;
    }

    Timer{
        id:delaySlideExport
        interval:root.msWaitDelayBeforeExport
        repeat: false
        onTriggered: pm.addSlidePDFExport( loader.item)
    }

    Loader{
        id:loader
        anchors.fill:parent
        source: root.slideUrl
        onStatusChanged: {
            if ((root.exportRunning) && (status === Loader.Ready))
                delaySlideExport.restart()
        }
    }
    Popup{
        anchors.centerIn: parent
        width:parent.width*0.6
        height:300
        focus:true
        visible:true
        closePolicy: Popup.NoAutoClose
        dim:true
        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 10

            Label{
                id:text
                text:qsTr("Exporting to pdf slide %1 of %2").arg(root.currentSlideIdx).arg(root.nbSlides)
                Layout.fillWidth:true
            }
            ProgressBar{
                from: 0
                to:root.nbSlides
                value: root.currentSlideIdx
                Layout.fillWidth:true

            }
            Button{
                visible: root.exportRunning
                text:"Start"
                onClicked: root.startExport()
            }
        }
    }
}


