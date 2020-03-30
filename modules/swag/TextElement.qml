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
    property alias text:content.text
    property alias color:content.color
    property alias elide:content.elide
    property alias fontSizeMode:content.fontSizeMode
    property alias wrapMode:content.wrapMode
    property alias textFormat:content.textFormat
    property alias horizontalAlignment:content.horizontalAlignment
    property alias verticalAlignment:content.verticalAlignment
    property alias minimumPointSize:content.minimumPointSize
    property alias fontPointSize:content.font.pointSize

    elementType : "TextElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"text","default":""})
        dumpedProperties.push( {"name":"color","default":""})
        dumpedProperties.push( {"name":"elide","default":Text.ElideNone})
        dumpedProperties.push( {"name":"fontSizeMode","default":Text.FixedSize})
        dumpedProperties.push( {"name":"wrapMode","default":Text.NoWrap})
        dumpedProperties.push( {"name":"textFormat","default":Text.AutoText})
        dumpedProperties.push( {"name":"horizontalAlignment","default":Text.AlignLeft})
        dumpedProperties.push( {"name":"verticalAlignment","default":Text.AlignTop})
        dumpedProperties.push( {"name":"minimumPointSize","default":12})
        dumpedProperties.push( {"name":"fontPointSize","default":14})
    }

    contentItem:ScrollView{
        enabled:!NavMan.editMode
        clip:true
        Label{
            id:content
            width:root.width
            height:root.height
        }
    }

    editItem : ScrollView{
            enabled:NavMan.editMode && !NavMan.elementItemToPosition
            width:root.width
            height: root.height

            TextArea{
                id: textArea
                width : textArea.contentWidth
                text:root.text
                wrapMode:content.wrapMode
                font.family: content.font.family
                font.pixelSize: content.font.pixelSize
                color:content.color

            }
            Button{
                text:"Done"
                visible: root.text !== textArea.text
                anchors.right:parent.right
                onClicked: {
                    root.text = textArea.text
                    NavMan.actionReloadSlide(true);
                }
            }
        }


    editorComponent:Component{
        Column{
            width:parent.width
            GroupBox{
                title:qsTr("Text")
                width:parent.width
                CodeEditor{
                    langage: "json"
                    width:parent.width
                    height:200
                    code:target.text
                    onEditingFinish: target.text = code
                }
            }
            GroupBox{
                title:qsTr("minimumPointSize")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.minimumPointSize : ""
                    onTextEdited: target.minimumPointSize = Number(text)
                }
            }
            GroupBox{
                title:qsTr("fontPointSize")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.fontPointSize : ""
                    onTextEdited: target.fontPointSize = Number(text)
                }
            }
            GroupBox{
                title:qsTr("Color")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.color : ""
                    onTextEdited: target.color = text
                }
            }
            GroupBox{
                title:qsTr("elide")
                ComboBox{
                    model: ["Left", "Middle", "Right","None"]
                    currentIndex: currentIndex = target.elide
                    onActivated: target.elide = currentIndex
                }
            }
            GroupBox{
                title:qsTr("wrapMode")
                ComboBox{
                    model: ["No wrap", "WordWrap", "--reserved--", "WrapAnywhere", "Wrap"]
                    currentIndex: currentIndex = target.wrapMode
                    onActivated: target.wrapMode = currentIndex
                }
            }
            GroupBox{
                title:qsTr("horizontalAlignment")
                ComboBox{
                    textRole:"t";valueRole:"v"
                    model: [{v:1, t:"Left"}, {v:2, t:"Right"}, {v:4, t:"Center"},{v:8, t:"Justify"}]
                    currentIndex: currentIndex = indexOfValue(target.horizontalAlignment)
                    onActivated: target.horizontalAlignment = currentValue
                }
            }
            GroupBox{
                title:qsTr("verticalAlignment")
                ComboBox{
                    textRole:"t";valueRole:"v"
                    model: [{v:32, t:"Top"}, {v:64, t:"Bottom"}, {v:128, t:"Center"}]
                    currentIndex: currentIndex = indexOfValue(target.verticalAlignment)
                    onActivated: target.verticalAlignment = currentValue
                }
            }
            GroupBox{
                title:qsTr("fontSizeMode")
                ComboBox{
                    model: ["FixedSize", "HorizontalFit", "VerticalFit","Fit"]
                    currentIndex: currentIndex = target.fontSizeMode
                    onActivated: target.fontSizeMode = currentIndex
                }
            }
            GroupBox{
                title:qsTr("textFormat")
                ComboBox{
                    model: ["PlainText", "RichText", "AutoText","MarkdownText", "StyledText"]
                    currentIndex: currentIndex = target.textFormat
                    onActivated: target.textFormat = currentIndex
                }
            }

        }
    }


}

