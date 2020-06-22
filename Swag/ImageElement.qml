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
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0

Element{
    id:root

    height : 50
    width : 100

    property alias source: image.source
    property alias fillMode : image.fillMode


    elementType : "ImageElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"source","default":pm.documentUrl("icon1024.png","res/SwagLogo.iconset/")})
        dumpedProperties.push( {"name":"fillMode","default":Image.Stretch})

    }

    contentItem:Image{
        id:image
        source:pm.documentUrl("icon1024.png","res/SwagLogo.iconset/") //default image
    }

    editorComponent:Component{
        Column{
            width:parent.width
            spacing : 3
            GroupBox{
                title:qsTr("source")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.source : ""
                    onTextEdited: target.source = text
                }
            }
            GroupBox{
                title:qsTr("fillMode")
                width:parent.width
                ComboBox{
                    width:parent.width
                    model: ["Stretch", "PreserveAspectFit", "PreserveAspectCrop","Tile","TileVertically","TileHorizontally","Pad"]
                    currentIndex: currentIndex = target.fillMode
                    onActivated: target.fillMode = currentIndex
                }
            }

        }
    }


}

