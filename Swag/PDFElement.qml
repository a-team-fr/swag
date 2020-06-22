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
import Swag 1.0

Element{
    id:root
    property bool permissive : false
    property string pdfPath: pm.documentUrl("pdfSample.pdf","examples/Gallery/{08074c7f-ec51-448a-b67b-a22a5892cd95}/")
    //readonly property string pdfSource : pm.lookForLocalFile(pdfPath)
    //onPdfSourceChanged: console.log(pdfSource)

    elementType : "PDFElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"pdfPath","default":""})
        dumpedProperties.push( {"name":"permissive","default":false})

    }

    contentItem:WebView{
        //url:"file:///users/charby/Documents/Git/swag/deps/pdfjs/web/viewer.html?file=file://Users/charby/Documents/Swag/Gallery/pdfSample.pdf&permissive=false"
        url:"file:///"+pm.installPath + "/deps/pdfjs/web/viewer.html?file="+pm.lookForLocalFile(root.pdfPath) +"&permissive="+root.permissive
        //onUrlChanged:console.log("WebviewURL:"+url)
    }

    editorComponent:Component{
        Column{
            width:parent.width
            spacing :2
            GroupBox{
                title:qsTr("pdfPath")
                width:parent.width
                TextField{
                    width:parent.width
                    //text:target ? target.pdfPath : ""
                    Component.onCompleted: text = target.pdfPath;
                    onTextEdited: target.pdfPath = text
                }
            }

            CheckDelegate{
                text:qsTr("permissive")
                width:parent.width
                checked:target.permissive
                ToolTip.text:qsTr("Disable protection on cross domain request (use it only if you are 100% sure of the origin of your document)")
                ToolTip.visible: hovered
                onToggled: target.permissive = checked
            }

        }
    }


}

