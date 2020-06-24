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
import MaterialIcons 1.0
import FontAwesome 1.0
Element{
    id:root

    //height : 20
    //width : 100
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

            FormItem{
                title: qsTr("minimumPointSize")
                width: parent.width
                text: target.minimumPointSize
                onEditingFinished: target.minimumPointSize = Number(text)
                textField.validator: IntValidator{}
            }
            FormItem{
                title: qsTr("fontPointSize")
                width: parent.width
                text: target.fontPointSize
                onEditingFinished: target.fontPointSize = Number(text)
                textField.validator: IntValidator{}
            }
            FormItem{
                title: qsTr("color")
                width: parent.width
                selectedColor: target.color
                showColorSelector: true
                onColorPicked: target.color = selectedColor
                pickerParent : root.parent
            }

            FormItem{
                title:qsTr("elide")
                width:parent.width
                comboBox.model: ["Left", "Middle", "Right","None"]
                comboBox.currentIndex: target.elide
                onActivated: target.elide = comboBox.currentIndex

            }
            FormItem{
                title:qsTr("wrapMode")
                width:parent.width

                comboBox.model: ["No wrap", "WordWrap", "--reserved--", "WrapAnywhere", "Wrap"]
                comboBox.currentIndex: target.wrapMode
                onActivated: target.wrapMode = comboBox.currentIndex

            }
            RowLayout{
                width:parent.width
                FAButton{
                    ToolTip.text:qsTr("Left horizontal alignment")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_align_left
                    checked: target.horizontalAlignment === Text.AlignLeft
                    toggleButton: true
                    onClicked: target.horizontalAlignment = Text.AlignLeft
                }
                FAButton{
                    ToolTip.text:qsTr("Center horizontal alignment")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_align_center
                    checked: target.horizontalAlignment === Text.AlignHCenter
                    toggleButton: true
                    onClicked: target.horizontalAlignment = Text.AlignHCenter
                }
                FAButton{
                    ToolTip.text:qsTr("Right horizontal alignment")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_align_right
                    checked: target.horizontalAlignment === Text.AlignRight
                    toggleButton: true
                    onClicked: target.horizontalAlignment = Text.AlignRight
                }
                FAButton{
                    ToolTip.text:qsTr("Justify horizontal alignment")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_align_justify
                    checked: target.horizontalAlignment === Text.AlignJustify
                    toggleButton: true
                    onClicked: target.horizontalAlignment = Text.AlignJustify
                }
            }
            RowLayout{
                width:parent.width
                FAButton{
                    ToolTip.text:qsTr("Top vertical alignment")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.vertical_align_top
                    checked: target.verticalAlignment === Text.AlignTop
                    //toggleButton: true
                    onClicked: target.verticalAlignment = Text.AlignTop
                }
                FAButton{
                    ToolTip.text:qsTr("Center vertical alignment")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.vertical_align_center
                    checked: target.verticalAlignment === Text.AlignVCenter
                    //toggleButton: true
                    onClicked: target.verticalAlignment = Text.AlignVCenter
                }
                FAButton{
                    ToolTip.text:qsTr("Bottom vertical alignment")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.vertical_align_bottom
                    checked: target.verticalAlignment === Text.AlignBottom
                    //toggleButton: true
                    onClicked: target.verticalAlignment = Text.AlignBottom
                }
            }
            FormItem{
                width:parent.width
                title:qsTr("fontSizeMode")
                comboBox.model: ["FixedSize", "HorizontalFit", "VerticalFit","Fit"]
                comboBox.currentIndex: target.fontSizeMode
                onActivated: target.fontSizeMode = comboBox.currentIndex
            }

            FormItem{
                width:parent.width
                title:qsTr("textFormat")
                comboBox.model: ["PlainText", "RichText", "AutoText","MarkdownText", "StyledText"]
                comboBox.currentIndex: target.textFormat
                onActivated: target.textFormat = comboBox.currentIndex
            }


            FormItem{
                width:parent.width
                title:qsTr("font")
                comboBox.model: Qt.fontFamilies()
                //currentIndex: indexOfValue(target.fontFamily)
                Component.onCompleted: comboBox.currentIndex = comboBox.indexOfValue(target.fontFamily)
                onActivated: target.fontFamily = comboBox.currentValue
            }

            RowLayout{
                width:parent.width
                FAButton{
                    ToolTip.text:qsTr("bold")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_bold
                    checked: target.bold
                    toggleButton: true
                    onClicked: target.bold = checked
                }
                FAButton{
                    ToolTip.text:qsTr("italic")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_italic
                    checked: target.italic
                    toggleButton: true
                    onClicked: target.italic = checked
                }
                FAButton{
                    ToolTip.text:qsTr("underline")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_underlined
                    checked: target.underline
                    toggleButton: true
                    onClicked: target.underline = checked
                }
                FAButton{
                    ToolTip.text:qsTr("strikeout")
                    ToolTip.visible : hovered
                    icon : MaterialIcons.format_strikethrough
                    checked: target.strikeout
                    toggleButton: true
                    onClicked: target.strikeout = checked
                }
            }


            FormItem{
                title: qsTr("weight")
                width: parent.width
                text: target.fontWeight
                onEditingFinished: target.fontWeight = Number(text)
                textField.validator: IntValidator{}
            }

            FormItem{
                width:parent.width
                title:qsTr("style")
                comboBox.textRole:"t";comboBox.valueRole:"v"
                comboBox.model: [{v:Text.Normal, t:"Normal"}, {v:Text.Outline, t:"Outline"}, {v:Text.Raised, t:"Raised"}, {v:Text.Sunken, t:"Sunken"}]
                Component.onCompleted: comboBox.currentIndex = comboBox.indexOfValue(target.style)
                onActivated: target.style = comboBox.currentValue

            }
            FormItem{
                title: qsTr("styleColor")
                width: parent.width
                selectedColor: target.styleColor
                showColorSelector: true
                onColorPicked: target.styleColor = selectedColor
                pickerParent : root.parent
            }


            FormItem{
                width:parent.width
                title:qsTr("capitalization")
                comboBox.textRole:"t";comboBox.valueRole:"v"
                comboBox.model: [{v:Font.MixedCase, t:"MixedCase"}, {v:Font.AllUppercase, t:"AllUppercase"}, {v:Font.AllLowercase, t:"AllLowercase"}, {v:Font.SmallCaps, t:"SmallCaps"}, {v:Font.Capitalize, t:"Capitalize"}]
                //currentIndex: indexOfValue(target.capitalization)
                Component.onCompleted: comboBox.currentIndex = comboBox.indexOfValue(target.capitalization)
                onActivated: target.capitalization = comboBox.currentValue

            }



            //background
            ToolSeparator{ orientation: Qt.Horizontal; width: parent.width; anchors.horizontalCenter : parent.horizontalCenter}


            FormItem{
                title: qsTr("color")
                width: parent.width
                selectedColor: target.bckgColor
                showColorSelector: true
                onColorPicked: target.bckgColor = selectedColor
                pickerParent : root.parent
            }
            FormItem{
                title: qsTr("border color")
                width: parent.width
                selectedColor: target.bckgBorderColor
                showColorSelector: true
                onColorPicked: target.bckgBorderColor = selectedColor
                pickerParent : root.parent
            }
            FormItem{
                title: qsTr("border width")
                width: parent.width
                text: target.bckgBorderWidth
                onEditingFinished: target.bckgBorderWidth = Number(text)
                textField.validator: IntValidator{}
            }

        }
    }


}




