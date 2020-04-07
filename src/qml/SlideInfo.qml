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
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import fr.ateam.swag 1.0
import Swag 1.0
import FontAwesome 1.0


Frame{
    id:root

    Flickable {
        anchors.fill:parent
        anchors.margins: 10
        clip:true
        contentHeight: content.childrenRect.height
        ColumnLayout{
            id:content
            width: parent.width
            spacing : 5
          GroupBox{
              title:qsTr("Title")
              Layout.fillWidth: true
              TextField{
                  id:title
                  width:parent.width
                  text:pm.lstSlides[pm.slideSelected].title
                  onEditingFinished: pm.saveSlideSettings("title", text)
              }
          }
          RowLayout{
              Layout.fillWidth: true
              GroupBox{
                  title:qsTr("x")
                  TextField{
                      id:propX
                      width:parent.width
                      text:pm.lstSlides[pm.slideSelected].x
                      onEditingFinished: pm.saveSlideSettings("x", Number(text))
                  }
              }
              GroupBox{
                  title:qsTr("y")
                  TextField{
                      id:propY
                      width:parent.width
                      text:pm.lstSlides[pm.slideSelected].y
                      onEditingFinished: pm.saveSlideSettings("y", Number(text))
                  }
              }
              GroupBox{
                  title:qsTr("rotation")
                  TextField{
                      id:propRotation
                      width:parent.width
                      text:pm.lstSlides[pm.slideSelected].rotation
                      onEditingFinished: pm.saveSlideSettings("rotation", Number(text))
                  }
              }
              GroupBox{
                  title:qsTr("width")
                  TextField{
                      id:propWidth
                      width:parent.width
                      text:pm.lstSlides[pm.slideSelected].width
                      onEditingFinished: pm.saveSlideSettings("width", Number(text))
                  }
              }
              GroupBox{
                  title:qsTr("height")
                  TextField{
                      id:propHeight
                      width:parent.width
                      text:pm.lstSlides[pm.slideSelected].height
                      onEditingFinished: pm.saveSlideSettings("height", Number(text))
                  }
              }
          }


    //      GroupBox{
    //          title:qsTr("Layout")
    //          ComboBox{
    //              id:propLayout
    //              model: ["Free", "Column"]
    //              currentIndex: currentIndex = find(pm.lstSlides[pm.slideSelected].layout)
    //              onActivated: pm.saveSlideSettings("layout", currentText)
    //          }
    //      }
          FAButton{
              icon:FontAwesome.trash
              iconColor:"red"
              text:qsTr("Remove slide")
              onClicked: {
                  pm.removeSlide();
                  pm.displayType = PM.Slide;
              }
          }
        }
    }
}
