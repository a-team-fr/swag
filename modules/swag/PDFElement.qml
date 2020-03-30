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
    property bool permissive : false
    property string pdfPath: "https://github.com/mozilla/pdf.js/blob/master/test/pdfs/alphatrans.pdf"
    readonly property url pdfSource : pm.lookForLocalFile(pdfPath)


    elementType : "PDFElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"pdfPath","default":""})
        dumpedProperties.push( {"name":"permissive","default":false})

    }

    contentItem:WebView{
        url:Qt.resolvedUrl(pm.installPath + "/deps/pdfjs/web/viewer.html?file="+root.pdfSource +"&permissive="+root.permissive)

    }

    editorComponent:Component{
        Column{
            width:parent.width
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
            GroupBox{
                title:qsTr("permissive")
                width:parent.width
                CheckBox{
                    width:parent.width
                    //text:target ? target.pdfPath : ""
                    checked:target.permissive
                    text:"Disable protection on cross domain request (use it only if you are 100% sure of the origin of your document)"
                    onToggled: target.permissive = checked
                }
            }

        }
    }


}

