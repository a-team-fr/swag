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
//        function doitnow(code){
//            return eval(code);
//        }

        onClicked: {
            try{
                root.doitnow(root.onClicked)
               }
            catch(error) {
                console.log(error)
               }
        }
    }

    editorComponent:Component{
        Column{
            width:parent.width
            spacing :2
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

            FormItem{
                title:qsTr("text")
                width:parent.width
                text:target.text
                onEditingFinished: target.text = text

            }
            FormItem{
                title: qsTr("Icon")
                width: parent.width
                selectedIcon: target.icon
                showIconSelector: true
                onIconPicked: target.icon = selectedIcon
                pickerParent : root.parent
            }

            FormItem{
                title: qsTr("IconColor")
                width: parent.width
                selectedColor: target.iconColor
                showColorSelector: true
                onColorPicked: target.iconColor = selectedColor
                pickerParent : root.parent
            }
            FormItem{
                title: qsTr("Color")
                width: parent.width
                selectedColor: target.color
                showColorSelector: true
                onColorPicked: target.color = selectedColor
                pickerParent : root.parent
            }

            SwitchDelegate{
                text:qsTr("decorate")
                width:parent.width
                checked: target.decorate
                onToggled: target.decorate = checked

            }

            SwitchDelegate{
                text:qsTr("autoFitText")
                width:parent.width
                checked: target.autoFitText
                onToggled: target.autoFitText = checked
            }

        }
    }


}

