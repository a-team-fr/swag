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
    property string onEditingFinished: ""

    property alias placeholder : content.placeholderText
    //readonly property alias hovered : content.hovered
    //property alias hoveredEnabled : content.hoveredEnabled
    //property alias color : content.color
    //property alias echoMode : content.echoMode
    property alias text : content.text
    property alias wrapMode : content.wrapMode


    elementType : "InputElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"text","default":""})
        dumpedProperties.push( {"name":"placeholder","default":""})
        dumpedProperties.push( {"name":"onEditingFinished","default":""})
        dumpedProperties.push( {"name":"wrapMode","default":TextInput.NoWrap})


    }

    contentItem:TextField{
        id:content
        function doitnow(code){
            return eval(code);
        }

        onEditingFinished: {
            try{
                doitnow(root.onEditingFinished)
               }
            catch(error) {
                console.log(error)
               }
        }
    }



    editorComponent:Component{
        Column{
            width:parent.width
            spacing : 3
            GroupBox{
                title:qsTr("onEditingFinished:")
                width:parent.width
                CodeEditor{
                    langage: "javascript"
                    width:parent.width
                    height:200
                    code:target.onEditingFinished
                    onEditingFinish: target.onEditingFinished = code
                }
            }
            GroupBox{
                title:qsTr("text")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.text : ""
                    onTextEdited: target.text = text
                }
            }
            GroupBox{
                title:qsTr("placeholder")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.placeholder : ""
                    onTextEdited: target.placeholder = text
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


        }
    }


}

