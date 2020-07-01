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
import MaterialIcons 1.0


Frame{
    id:root

    readonly property real pageRatio : pm.slidePageRatio( pm.slideSelected)
    //onPageRatioChanged: console.log("pageRatioChanged:" + pageRatio)
    readonly property bool isLandscape : pageRatio > 1

    CloseButton{}

    Flickable {
        anchors.fill:parent
        anchors.margins: 10
        clip:true
        contentHeight: content.childrenRect.height
        ColumnLayout{
            id:content
            width: parent.width
            spacing : 5
            FormItem{
                title:qsTr("Title")
                Layout.fillWidth: true

                text:pm.lstSlides[pm.slideSelected].title
                onEditingFinished: pm.saveSlideSettings("title", text)

            }
            RowLayout{
                Layout.fillWidth: true
                FormItem{
                    title:qsTr("x")

                    text:pm.lstSlides[pm.slideSelected].x
                    onEditingFinished: pm.saveSlideSettings("x", Number(text))

                }
                FormItem{
                    title:qsTr("y")

                    text:pm.lstSlides[pm.slideSelected].y
                    onEditingFinished: pm.saveSlideSettings("y", Number(text))

                }
                FormItem{
                    title:qsTr("rotation")

                    text:pm.lstSlides[pm.slideSelected].rotation
                    onEditingFinished: pm.saveSlideSettings("rotation", Number(text))

                }
            }
            RowLayout{
                Layout.fillWidth: true
                FormItem{
                    title:qsTr("Page ratio")

                    extraContent:Component{Row{
                        spacing : 5
                        FAButton{
                            icon: MaterialIcons.crop_16_9
                            checked : root.pageRatio === 16/9 || root.pageRatio === 9/16
                            onClicked:pm.saveSlideSettings( "pageRatio", root.isLandscape ? 16/9 : 9/16 )
                        }
                        FAButton{
                            icon: MaterialIcons.crop_3_2
                            checked : root.pageRatio === 3/2 || root.pageRatio === 2/3
                            onClicked:pm.saveSlideSettings( "pageRatio", root.isLandscape ? 3/2 : 2/3)
                        }
                        FAButton{
                            icon: MaterialIcons.crop_5_4
                            checked : root.pageRatio === 5/4 || root.pageRatio === 4/5
                            onClicked:pm.saveSlideSettings( "pageRatio",  root.isLandscape ? 5/4 : 4/5 )
                        }
                        FAButton{
                            icon: MaterialIcons.crop_7_5
                            checked : root.pageRatio === 7/5 || root.pageRatio === 5/7
                            onClicked:pm.saveSlideSettings( "pageRatio", root.isLandscape ? 7/5 : 5/7)
                        }
                        FAButton{
                            icon: MaterialIcons.crop_din
                            checked : root.pageRatio === 1
                            onClicked:pm.saveSlideSettings( "pageRatio", 1.)
                        }
                    }}

                }

            }
            RowLayout{
                Layout.fillWidth: true
                FormItem{
                    title:qsTr("Page layout")

                    extraContent:Component{Row{
                        spacing : 5
                        FAButton{
                            icon: MaterialIcons.landscape
                            checked : root.isLandscape
                            onClicked: pm.saveSlideSettings( "pageRatio",  1 / root.pageRatio)
                        }
                        FAButton{
                            icon: MaterialIcons.portrait
                            checked : !root.isLandscape
                            onClicked: pm.saveSlideSettings( "pageRatio", 1 / root.pageRatio)
                        }
                    }}

                }

            }

            FAButton{
                icon:MaterialIcons.save
                text:qsTr("Save slide settings")
                onClicked: pm.displayType = pm.loaded ?  PM.Slide :PM.Welcome
            }

            FAButton{
                icon:MaterialIcons.remove
                iconColor:"red"
                text:qsTr("Delete slide")
                enabled : pm.lstSlides.length > 1
                onClicked: {
                    pm.removeSlide();
                    pm.displayType = PM.Slide;
                }
            }
        }
    }
}
