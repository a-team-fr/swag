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
import fr.ateam.swag 1.0
import QtWebView 1.14

Element{
    id:root
    property string url: "https://swagsoftware.net"

    height : 480
    width : 640

    elementType : "WebElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"url","default":"https://swagsoftware.net"})

    }

    contentItem:WebView{
        id:wv
        url: pm.lookForLocalFile(root.url)
    }

    editorComponent:Component{
        Column{
            width:parent.width
            visible:target
            FormItem{
                title:qsTr("url")
                width:parent.width
                text: target.url
                onTextEdited: target.url = text
            }

        }
    }


}

