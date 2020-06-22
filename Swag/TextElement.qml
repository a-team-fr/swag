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

    height : 20
    width : 100
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
    property color bckgColor : "transparent"
    property color bckgBorderColor : "black"
    property int bckgBorderWidth : 0

    property alias fontFamily : content.font.family
    property alias bold : content.font.bold
    property alias italic : content.font.italic
    property alias underline : content.font.underline
    property alias strikeout : content.font.strikeout
    property alias style : content.style
    property alias styleColor : content.styleColor
    property alias fontWeight : content.font.weight
    property alias capitalization : content.font.capitalization


    elementType : "TextElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"text","default":qsTr("A text element...")})
        dumpedProperties.push( {"name":"color","default":""})
        dumpedProperties.push( {"name":"elide","default":Text.ElideNone})
        dumpedProperties.push( {"name":"fontSizeMode","default":Text.FixedSize})
        dumpedProperties.push( {"name":"wrapMode","default":Text.NoWrap})
        dumpedProperties.push( {"name":"textFormat","default":Text.AutoText})
        dumpedProperties.push( {"name":"horizontalAlignment","default":Text.AlignLeft})
        dumpedProperties.push( {"name":"verticalAlignment","default":Text.AlignTop})
        dumpedProperties.push( {"name":"minimumPointSize","default":12})
        dumpedProperties.push( {"name":"fontPointSize","default":14})
        dumpedProperties.push( {"name":"bckgColor","default":"#00000000"})
        dumpedProperties.push( {"name":"bckgBorderColor","default":"#000000"})
        dumpedProperties.push( {"name":"bckgBorderWidth","default":0})

        dumpedProperties.push( {"name":"fontFamily","default":"Verdana"})
        dumpedProperties.push( {"name":"bold","default":false})
        dumpedProperties.push( {"name":"italic","default":false})
        dumpedProperties.push( {"name":"underline","default":false})
        dumpedProperties.push( {"name":"strikeout","default":false})
        dumpedProperties.push( {"name":"style","default":Text.Normal})
        dumpedProperties.push( {"name":"styleColor","default":"#000000"})
        dumpedProperties.push( {"name":"fontWeight","default":50})
        dumpedProperties.push( {"name":"capitalization","default":Font.MixedCase})
    }

    Component{
        id:defaultBackground
        Rectangle{
            color : root.bckgColor
            border.width: root.bckgBorderWidth
            border.color : root.bckgBorderColor
        }
    }


    contentItem:ScrollView{
        enabled:!pm.editMode
        clip:true
        //property var backcustomComponent : Qt.createComponent(root.backCustomComponent)
        Label{
            id:content
            //background: Loader{ sourceComponent:defaultBackground}
            color : pm.defaultTextColor
            text : qsTr("A text element...")
            font.family: "Verdana"
            width:root.width
            height:root.height
        }
    }


    editorComponent:Component{
        Column{

            width:parent.width
            spacing :2
            GroupBox{
                title:qsTr("Text")
                width:parent.width
                CodeEditor{
                    langage: "json"
                    showLineNumber: false
                    width:parent.width
                    height:200
                    code:target.text
                    onEditingFinish: target.text = code
                    focus:true
                }
            }
            TextFieldDelegate{
                title: qsTr("minimumPointSize")
                width: parent.width
                text: target.minimumPointSize
                onEditingFinished: target.minimumPointSize = Number(text)
                content.validator: IntValidator{}
            }
            TextFieldDelegate{
                title: qsTr("fontPointSize")
                width: parent.width
                text: target.fontPointSize
                onEditingFinished: target.fontPointSize = Number(text)
                content.validator: IntValidator{}
            }
            TextFieldDelegate{
                title: qsTr("color")
                width: parent.width
                text: target.color
                onEditingFinished: target.color = text
            }

            GroupBox{
                title:qsTr("elide")
                width:parent.width
                ComboBox{
                    width:parent.width
                    model: ["Left", "Middle", "Right","None"]
                    currentIndex: currentIndex = target.elide
                    onActivated: target.elide = currentIndex
                }
            }
            GroupBox{
                title:qsTr("wrapMode")
                width:parent.width
                ComboBox{
                    width:parent.width
                    model: ["No wrap", "WordWrap", "--reserved--", "WrapAnywhere", "Wrap"]
                    currentIndex: currentIndex = target.wrapMode
                    onActivated: target.wrapMode = currentIndex
                }
            }
            GroupBox{
                width:parent.width
                title:qsTr("horizontalAlignment")
                ComboBox{
                    width:parent.width
                    textRole:"t";valueRole:"v"
                    model: [{v:1, t:"Left"}, {v:2, t:"Right"}, {v:4, t:"Center"},{v:8, t:"Justify"}]
                    //currentIndex: currentIndex = indexOfValue(target.horizontalAlignment)
                    Component.onCompleted: currentIndex = indexOfValue(target.horizontalAlignment)
                    onActivated: target.horizontalAlignment = currentValue
                }
            }
            GroupBox{
                width:parent.width
                title:qsTr("verticalAlignment")
                ComboBox{
                    width:parent.width
                    textRole:"t";valueRole:"v"
                    model: [{v:32, t:"Top"}, {v:64, t:"Bottom"}, {v:128, t:"Center"}]
                    //currentIndex: currentIndex = indexOfValue(target.verticalAlignment)
                    Component.onCompleted: currentIndex = indexOfValue(target.verticalAlignment)
                    onActivated: target.verticalAlignment = currentValue
                }
            }
            GroupBox{
                width:parent.width
                title:qsTr("fontSizeMode")
                ComboBox{
                    width:parent.width
                    model: ["FixedSize", "HorizontalFit", "VerticalFit","Fit"]
                    currentIndex: target.fontSizeMode
                    onActivated: target.fontSizeMode = currentIndex
                }
            }
            GroupBox{
                width:parent.width
                title:qsTr("textFormat")
                ComboBox{
                    width:parent.width
                    model: ["PlainText", "RichText", "AutoText","MarkdownText", "StyledText"]
                    currentIndex: target.textFormat
                    onActivated: target.textFormat = currentIndex
                }
            }

            GroupBox{
                width:parent.width
                title:qsTr("font")
                Column{
                    anchors.fill:parent
                    ComboBox{
                        width:parent.width
                        model: Qt.fontFamilies()
                        //currentIndex: indexOfValue(target.fontFamily)
                        Component.onCompleted: currentIndex = indexOfValue(target.fontFamily)
                        onActivated: target.fontFamily = currentValue
                    }
                    SwitchDelegate{
                        text:qsTr("bold")
                        width:parent.width
                        checked: target.bold
                        onToggled: target.bold = checked
                    }
                    SwitchDelegate{
                        text:qsTr("italic")
                        width:parent.width
                        checked: target.italic
                        onToggled: target.italic = checked
                    }
                    SwitchDelegate{
                        text:qsTr("underline")
                        width:parent.width
                        checked: target.underline
                        onToggled: target.underline = checked
                    }
                    SwitchDelegate{
                        text:qsTr("strikeout")
                        width:parent.width
                        checked: target.strikeout
                        onToggled: target.strikeout = checked
                    }
                    TextFieldDelegate{
                        title: qsTr("weight")
                        width: parent.width
                        text: target.fontWeight
                        onEditingFinished: target.fontWeight = Number(text)
                        content.validator: IntValidator{}
                    }

                    GroupBox{
                        width:parent.width
                        title:qsTr("style")
                        Column{
                            anchors.fill : parent
                            ComboBox{
                                width:parent.width
                                textRole:"t";valueRole:"v"
                                model: [{v:Text.Normal, t:"Normal"}, {v:Text.Outline, t:"Outline"}, {v:Text.Raised, t:"Raised"}, {v:Text.Sunken, t:"Sunken"}]
                                //currentIndex: indexOfValue(target.style)
                                Component.onCompleted: currentIndex = indexOfValue(target.style)
                                onActivated: target.style = currentValue
                            }
                            TextFieldDelegate{
                                title: qsTr("style color")
                                width: parent.width
                                text: target.styleColor
                                onEditingFinished: target.styleColor = text
                            }
                        }
                    }
                    GroupBox{
                        width:parent.width
                        title:qsTr("capitalization")
                        ComboBox{
                            width:parent.width
                            textRole:"t";valueRole:"v"
                            model: [{v:Font.MixedCase, t:"MixedCase"}, {v:Font.AllUppercase, t:"AllUppercase"}, {v:Font.AllLowercase, t:"AllLowercase"}, {v:Font.SmallCaps, t:"SmallCaps"}, {v:Font.Capitalize, t:"Capitalize"}]
                            //currentIndex: indexOfValue(target.capitalization)
                            Component.onCompleted: currentIndex = indexOfValue(target.capitalization)
                            onActivated: target.capitalization = currentValue
                        }
                    }
                }


            }

            GroupBox{
                width:parent.width
                title:qsTr("Background")

                Column{
                    anchors.fill:parent
                TextFieldDelegate{
                    title: qsTr("color")
                    width: parent.width
                    text: target.bckgColor
                    onEditingFinished: target.bckgColor = text
                }
                TextFieldDelegate{
                    title: qsTr("border color")
                    width: parent.width
                    text: target.bckgBorderColor
                    onEditingFinished: target.bckgBorderColor = text
                }
                TextFieldDelegate{
                    title: qsTr("border width")
                    width: parent.width
                    text: target.bckgBorderWidth
                    onEditingFinished: target.bckgBorderWidth = Number(text)
                    content.validator: IntValidator{}
                }
                }
            }

        }
    }


}

