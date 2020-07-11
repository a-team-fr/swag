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
import QtQuick.Layouts 1.12
import fr.ateam.swag 1.0
import QtQuick.Controls.Material 2.14
import Swag 1.0

Frame{
    id:root
    CloseButton{}

    Flickable {
        anchors.fill: parent
        anchors.margins: 10
        clip:true
        contentHeight: content.childrenRect.height

        ColumnLayout{
            id:content
            width: parent.width
            spacing : 10

            FormItem{
                title:qsTr("Title")
                Layout.fillWidth: true
                text:pm.prezProperties.title
                onEditingFinished: pm.saveSwagSetting("title", pm.prezProperties.title)

            }

            FormItem{
                title:qsTr("Author")
                Layout.fillWidth: true
                enabled:false
                text:pm.prezProperties.author
            }

            //////////  DISPLAY MODE deactivated for now
            //              GroupBox{
            //                  title:qsTr("Display Mode")
            //                  Layout.fillWidth: true
            //                  ComboBox{
            //                      width:parent.width
            //                      model: ["Loader", "ListView", "FlatView"]
            //                      onActivated: pm.saveSwagSetting("displayMode", currentText)
            //                      Component.onCompleted: currentIndex = find(pm.prezProperties.displayMode)
            //                  }
            //              }


            Column{
                Layout.fillWidth: true
                RowLayout{
                    width:parent.width
                    FormItem{
                        title:qsTr("Background image")
                        width:parent.width / 2
                        comboBox.model: ["desert-279862_1920.jpg", "desert-790640_1920.jpg", "road-1303617_1920.jpg"]
                        onActivated: pm.saveSwagSetting("defaultBackground", "import QtQuick 2.14;Image{ source:'qrc:/res/"+comboBox.currentText+"';}")
                    }
                    FormItem{
                        title:qsTr("Background flat color")
                        width:parent.width / 2
                        showColorSelector: true
                        onColorPicked: pm.saveSwagSetting("defaultBackground", "import QtQuick 2.14;Rectangle{ color:'"+selectedColor+"';}");
                        pickerParent : root
                    }
                }

                CodeEditor{
                    width:parent.width
                    style:NavMan.settings.defaultSyntaxHighlightingStyle
                    onEditingFinish: pm.saveSwagSetting("defaultBackground", code)
                    code:pm.prezProperties.defaultBackground
                }
            }


            FormItem{
                Layout.fillWidth: true
                title:qsTr("default text color")
                selectedColor: pm.defaultTextColor
                showColorSelector: true
                onColorPicked: pm.defaultTextColor = selectedColor
                pickerParent : root
            }



        }

    }

}
