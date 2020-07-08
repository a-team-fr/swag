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
import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0
import MaterialIcons 1.0

Element{
    id:root
    //property string code :""
    elementType : "CodeElement"

    property alias showEditor : renderer.showEditor
    property alias showRenderer : renderer.showRenderer
    property alias style : renderer.style
    property alias code : renderer.code
    property alias langage : renderer.langage
    //property alias rendererSource : renderer.rendererSource
    property alias renderCode : renderer.renderCode
    property alias showEditorPanel :renderer.showEditorPanel


    Component.onCompleted: {
        dumpedProperties.push( {"name":"showEditor","default":false})
        dumpedProperties.push( {"name":"showRenderer","default":true})
        dumpedProperties.push( {"name":"style","default":""})
        dumpedProperties.push( {"name":"code","default":""})
        dumpedProperties.push( {"name":"langage","default":""})
        dumpedProperties.push( {"name":"renderCode","default":true})
        dumpedProperties.push( {"name":"showEditorPanel","default":""})
    }

    contentItem:CodeRenderer{
        id:renderer
        anchors.fill:parent
        code : "Text{ text:'Hello world'}"

    }

    editorComponent:Component{
        Column{
            visible : target
            width:parent.width
            spacing:2

            RowLayout{
                width:parent.width
                FAButton{
                    ToolTip.text:qsTr("showEditor")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.code
                    checked: target.showEditor
                    //toggleButton: true
                    onClicked: target.showEditor = !target.showEditor
                }
                FAButton{
                    ToolTip.text:qsTr("showRenderer")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.slideshow
                    checked: target.showRenderer
                    //toggleButton: true
                    onClicked: target.showRenderer = !target.showRenderer
                }
                FAButton{
                    ToolTip.text:qsTr("showEditorPanel")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.tab
                    checked: target.showEditorPanel
                    //toggleButton: true
                    onClicked: target.showEditorPanel = !target.showEditorPanel
                }
            }
            GroupBox{
                title:qsTr("Code")
                width:parent.width
                CodeEditor{
                    id:editor
                    code:target? target.code : ""
                    onEditingFinish: target.code = code
                    width:parent.width
                    height:200
                    focus : true
                }
            }


        }

    }


}

