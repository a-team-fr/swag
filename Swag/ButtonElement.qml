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
    property string onClicked: ""
    property alias icon : button.icon
    property alias text : button.text
    property alias color : button.color
    property alias iconColor : button.iconColor
    property alias decorate : button.decorate
    property alias autoFitText : button.autoFitText


    elementType : "ButtonElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"onClicked","default":""})
        dumpedProperties.push( {"name":"icon","default":""})
        dumpedProperties.push( {"name":"text","default":""})
        dumpedProperties.push( {"name":"color","default":""})
        dumpedProperties.push( {"name":"iconColor","default":""})
        dumpedProperties.push( {"name":"decorate","default":true})
        dumpedProperties.push( {"name":"autoFitText","default":false})


    }
    hoverEnabled: true

    contentItem:FAButton{
        id:button
        text:"Hey, I am a button!"
        function doitnow(code){
            return eval(code);
        }

        onClicked: {
            try{
                doitnow(root.onClicked)
               }
            catch(error) {
                console.log(error)
               }
        }
    }

    editItem : ScrollView{
            width:root.width
            height: root.height
            TextField{
                id: textArea
                width : root.width
                text:root.text
            }
            Button{
                text:"Done"
                visible: root.text !== textArea.text
                anchors.right:parent.right
                onClicked: {
                    root.text = textArea.text
                    NavMan.saveCurrentSlideAndReload(false);
                }
            }
        }


    editorComponent:Component{
        Column{
            width:parent.width
            GroupBox{
                title:qsTr("onClicked:")
                width:parent.width
                CodeEditor{
                    langage: "javascript"
                    width:parent.width
                    height:200
                    code:target.onClicked
                    onEditingFinish: target.onClicked = code
                }
            }
            GroupBox{
                title:qsTr("text")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.text : ""
                    onEditingFinished: target.text = text
                }
            }
            GroupBox{
                title:qsTr("Icon")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.icon : ""
                    onEditingFinished: target.icon = text
                }
            }
            GroupBox{
                title:qsTr("IconColor")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.iconColor : ""
                    onEditingFinished: target.iconColor = text
                }
            }
            GroupBox{
                title:qsTr("Color")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.color : ""
                    onEditingFinished: target.color = text
                }
            }

            GroupBox{
                title:qsTr("decorate")
                width:parent.width
                Switch{
                    checked: target ? target.decorate : false
                    onToggled: target.decorate = checked
                }
            }
            GroupBox{
                title:qsTr("autoFitText")
                width:parent.width
                Switch{
                    checked: target ? target.navigationFocus : false
                    onToggled: target.autoFitText = checked
                }
            }

        }
    }


}

