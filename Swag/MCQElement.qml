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
import FontAwesome 1.0

Element {
    id: root

    property string question : "Quelle est la réponse ?"
    property double answerHeight : 140

    property var dataMCQ:DataElement{}

    readonly property int nbCorrectAnswer : countNbCorrectAnswer(dataMCQ.count)


    function countNbCorrectAnswer( count){
        var nb = 0
        for (var i = 0; i < count; i++)
        {
            if (dataMCQ.lstModel.get(i).isCorrect)
                nb++;
        }
        return nb;
    }

    elementType: "MCQElement"

    Component.onCompleted: {
        dumpedProperties.push({"name": "question", "default": ""});
        dumpedProperties.push({"name": "answerHeight", "default": 100});
        dumpedProperties.push({"name": "dataMCQ", "default": []});

        dataMCQ.fields = [
                    {"name":"frontLayout", "type":DataElement.FieldType.ComboBox, "values":[{"value": FlipableElement.Mode.Overlapped, "label": "Overlapped"}, {"value": FlipableElement.Mode.TextLeft, "label": "TextLeft"}, {"value": FlipableElement.Mode.ImageLeft, "label": "ImageLeft"}]},
                    {"name":"frontText", "type":DataElement.FieldType.TextField},
                    {"name":"frontImage", "type":DataElement.FieldType.TextField},
                    {"name":"frontTextFill", "type":DataElement.FieldType.CheckBox},

                    {"name":"backLayout", "type":DataElement.FieldType.ComboBox, "values":[{"value": FlipableElement.Mode.Overlapped, "label": "Overlapped"}, {"value": FlipableElement.Mode.TextLeft, "label": "TextLeft"}, {"value": FlipableElement.Mode.ImageLeft, "label": "ImageLeft"}]},
                    {"name":"backText", "type":DataElement.FieldType.TextField},
                    {"name":"backImage", "type":DataElement.FieldType.TextField},
                    {"name":"backTextFill", "type":DataElement.FieldType.CheckBox},

                    {"name":"isCorrect", "type":DataElement.FieldType.CheckBox}
            ]
        dataMCQ.fieldsModifiable = false
    }


    contentItem: ColumnLayout{
        id:theQuestion
        property bool reveal : false
        Label{
            Layout.fillWidth: true
            Layout.fillHeight: true
            text:root.question
            fontSizeMode: Text.Fit
            minimumPointSize: 14
            font.pointSize: 50

        }
        ButtonGroup{ id:radioGroup}
        ScrollView{
            id:scroll
            width:parent.width
            Layout.fillHeight: true
            clip:true
            ListView{

                model:root.dataMCQ.lstModel
                //anchors.fill:parent
                spacing: 5
                delegate:Rectangle{
                    height:root.answerHeight
                    width:scroll.width
                    color:"transparent"
                    property bool isChecked: checkItem.item.checked
                    border.color : (model.isCorrect && isChecked) ? "green" : "red"
                    border.width: (theQuestion.reveal && (model.isCorrect || isChecked  )) ? 3 : 0
                    RowLayout{
                        anchors.fill: parent
                        anchors.margins: 5
                        Loader{
                            enabled:!theQuestion.reveal
                            id:checkItem
                            sourceComponent: root.nbCorrectAnswer === 1 ? radioButton : checkBox

                            Component{
                                id:checkBox
                                CheckBox{

                                }
                            }
                            Component{
                                id:radioButton
                                RadioButton{
                                    //id:checkItem
                                    ButtonGroup.group: radioGroup
                                }
                            }
                        }


                        FlipableElement{
                            Layout.fillWidth: true
                            height:parent.height
                            clickable : false
                            flipped: theQuestion.reveal && (model.backText || model.backImage)
                            frontLayout : model.frontLayout
                            frontText : model.frontText
                            frontImage : model.frontImage
                            frontTextFill:model.frontTextFill
                            backLayout : model.backLayout
                            backText : model.backText
                            backImage : model.backImage
                            backTextFill:model.backTextFill
                        }
                    }


                }
            }

        }

        FAButton{
            icon:FontAwesome.arrowRight
            text:qsTr("Validate my answer(s)")
            onClicked:theQuestion.reveal = !theQuestion.reveal
        }
    }

    editorComponent: Component {
        Column {
            width:parent.width
            GroupBox{
                title:qsTr("question")
                width:parent.width
                TextField{
                    anchors.fill:parent
                    text:target ? target.question : ""
                    onEditingFinished: target.question = text
                }
            }
            GroupBox{
                title:qsTr("answerHeight")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.answerHeight : ""
                    onEditingFinished: target.answerHeight = Number(text)
                }
            }

            GroupBox{
                title:qsTr("DataElement")
                width:parent.width
                height:loadedDataElement.item.height + 50
                Loader{
                    id:loadedDataElement
                    width:parent.width
                    sourceComponent: dataMCQ.editorComponent
                    property var target : dataMCQ
                }
            }





        }
    }
}
