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
import QtQuick.Controls 2.2
import fr.ateam.swag 1.0
import Swag 1.0

Pane {
    SwipeView{
        id:view
        anchors.fill: parent
        anchors.bottomMargin: 50
        clip:true
        Label {
            wrapMode: Text.WordWrap
            text:qsTr("<br>
<h2>S🤘ag is an effort for creating a presentation with QML easy.</h2>
sWag provides a set of dynamic elements :
<ol>
<li> Basic items : rectangle, text or image, buttons
<li> Media : Video or Camera, Maps
<li> Display : charts, dataviz
                </ol>. But sWag is basically interpreting QML file so you can program whatever you like...")

                    }
        Label {
            wrapMode: Text.WordWrap
            text:qsTr("<br>
                <h2>As an extensible tool, possible applications are not limited to presentions...</h2>
                Here is a short a list of things, you can do with sWag :
                <ol>
                <li> A polling, questionnary tools with Multiple Choice Questions
                <li> Gamebooks
                <li> Whatever things you can imagine...
                </ol>
                ")

                    }
        Label {
            wrapMode: Text.WordWrap
            text:qsTr("<br>
                <h2>Ready ?</h2>
                <ol>
                <li> Open the gallery
                <li> or create your own sWag !
                </ol>
                ")

                    }
    }
    PageIndicator {
          id: indicator

          count: view.count
          currentIndex: view.currentIndex

          anchors.top: view.bottom
          anchors.horizontalCenter: parent.horizontalCenter
      }


}
