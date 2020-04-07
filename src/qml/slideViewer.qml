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


ApplicationWindow {
    id: mainApp
    width: NavMan.windowWidth
    height: NavMan.windowHeight
    visible:true
    property alias slideUrl : loader.source
    property alias slide : loader.item

    property int currentSlide : 0
    property int nbSlides : 0

    onSlideChanged: console.log("slideChanged")

    Component.onCompleted: {
        NavMan.slideWidth = NavMan.windowWidth
        NavMan.slideHeight = NavMan.windowHeight
    }


    Frame{
        anchors.fill:parent
        anchors.margins: 10
        Loader{
            id:loader
            anchors.fill:parent
        }
        Popup{
            anchors.centerIn: parent
            width:parent.width*0.6
            height:300
            focus:true
            visible:true
            closePolicy: Popup.NoAutoClose
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 10

                Label{
                    id:text
                    text:qsTr("Exporting to pdf slide %1 of %2").arg(mainApp.currentSlide).arg(mainApp.nbSlides)
                    Layout.fillWidth:true
                }
                ProgressBar{
                    from: 0
                    to:mainApp.nbSlides
                    value: mainApp.currentSlide
                    Layout.fillWidth:true

                }
            }
        }
    }
}

