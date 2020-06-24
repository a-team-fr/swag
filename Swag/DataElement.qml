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
import QtQuick.Controls.Material 2.14
import MaterialIcons 1.0

Element {
    id: root

    property var lstModel : ListModel{ id:lstModel  }

    readonly property alias count: lstModel.count

    property bool fieldsModifiable : true

    enum FieldType {
        ComboBox,
        TextField,
        CheckBox
    }

    property var fields : []

    /*property var fields : [
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



    ListModel{
        id:lstModel
        ListElement{
            frontLayout : FlipableElement.Mode.TextLeft;
            frontText : "la réponse D..."
            frontImage : "qrc:/res/road-1303617_1920.jpg"
            frontTextFill:true
            backLayout : FlipableElement.Mode.ImageLeft;
            backText : "ben non...c'est pas un jeu à la con !"
            backImage : "qrc:/res/road-1303617_1920.jpg"
            backTextFill:true
            isCorrect:false
        }
        ListElement{
            frontLayout : FlipableElement.Mode.Overlapped;
            frontText : "42"
            frontImage : ""
            frontTextFill:true
            backLayout : FlipableElement.Mode.Overlapped;
            backText : "yeah that's the one !"
            backImage : ""
            backTextFill:true
            isCorrect:true
        }
        ListElement{
            frontLayout : FlipableElement.Mode.Overlapped;
            frontText : "j'en sais rien"
            frontImage : ""
            frontTextFill:true
            backLayout : FlipableElement.Mode.Overlapped;
            backText : ""
            backImage : ""
            backTextFill:true
            isCorrect:false
        }
        ListElement{
            frontLayout : FlipableElement.Mode.Overlapped;
            frontText : "42"
            frontImage : ""
            frontTextFill:true
            backLayout : FlipableElement.Mode.Overlapped;
            backText : "yeah that's another one !"
            backImage : ""
            backTextFill:true
            isCorrect:true
        }

    }*/


    function dumpData(object,rank, prop)
    {
        dump.slideDump="";
        dump.addTabulation( rank);
        dump.slideDump += "lstModel : ListModel{\n";

        for (var i=0; i< object["lstModel"].count;i++)
        {
            var obj = object["lstModel"].get(i);
            if (!obj) continue;
            dump.addTabulation( rank+1);
            dump.slideDump += "ListElement{\n";
            for (var p in obj)
                dump.dumpProperty(obj, p, rank+2)

            dump.addTabulation( rank+1);
            dump.slideDump += "}\n";
        }


        dump.addTabulation( rank);
        dump.slideDump += "}\n";
        return dump.slideDump;
    }

    SlideDumper{
        id:dump
    }

    elementType: "DataElement"

    Component.onCompleted: {
        dumpedProperties.push({"name": "lstModel", "default": "", "dumpFunction":dumpData});
        dumpedProperties.push({"name": "fields", "default": []});//,"dumpFunction":dumpFields });
    }


    contentItem: Item{}

    editorComponent: Component {
        Column{
            id:lst
            property int currentIndex : 0
            property bool isData : target.lstModel.count > 0
            property var currentElement : isData ? target.lstModel.get(currentIndex) : null

            property int fieldsReloader : 1
            function reload(){
                fieldsReloader++;
            }

            //width:parent.width
            spacing:10
            GroupBox{
                width:parent.width
                title:qsTr("Fields")
                visible : target.fieldsModifiable && !lst.isData
                ColumnLayout{
                    width:parent.width
                    FAButton{
                        icon:MaterialIcons.add_box
                        onClicked:{ target.fields.push({"name":"newField", "type":DataElement.FieldType.TextField});
                            lst.fieldsReloader++;
                        }
                        iconColor: "green"
                        text:qsTr("Add a new field")
                    }
                    Repeater{
                        model:fieldsReloader > 0 ? target.fields : target.fields //force model to be reload when fieldsReloader change
                        width:parent.width
                        delegate:RowLayout{
                            id:fieldRow
                            property int fieldIndex : index
                            TextField{
                                Layout.alignment: Qt.AlignTop
                                Layout.fillWidth: true
                                placeholderText: qsTr("Give this field a name identifyer")
                                text:modelData.name
                                onTextEdited: target.fields[index].name = text
                            }
                            ComboBox{
                                id:cbFieldType
                                Layout.alignment: Qt.AlignTop
                                Layout.minimumWidth: 150
                                model:[
                                    {name:"ComboBox", value : 0/*DataElement.FieldType.ComboBox*/},
                                    {name:"TextField", value : 1/*DataElement.FieldType.TextField*/},
                                    {name:"CheckBox", value : 2/*DataElement.FieldType.CheckBox*/}
                                ]
                                valueRole: "value"
                                textRole: "name"
                                onActivated: { target.fields[index].type = currentValue; }
                                Component.onCompleted: currentIndex = indexOfValue( modelData.type)//target.fields[index].type)
                            }
                            Item{
                                Layout.minimumWidth: 400
                                Layout.minimumHeight: modelData.type === DataElement.FieldType.ComboBox ? 100 : 0
                                clip:true
                                GroupBox{
                                    title: qsTr("ComboBoxOption")
                                    anchors.fill:parent
                                    visible:cbFieldType.currentValue === DataElement.FieldType.ComboBox

                                    Row{
                                        width:parent.width
                                        FAButton{
                                            icon:MaterialIcons.add_box
                                            onClicked:{
                                                if (target.fields[fieldRow.fieldIndex].values === undefined)
                                                    target.fields[fieldRow.fieldIndex].values = [];
                                                target.fields[fieldRow.fieldIndex].values.push({"label":"new option", "value":0})
                                                lst.reload()
                                            }
                                            iconColor: "green"
                                            //text:qsTr("Add a new option")
                                        }
                                        ListView{

                                            model:modelData.values
                                            width:parent.width - 50
                                            height:75
                                            clip:true
                                            delegate: RowLayout{
                                                TextField{
                                                    placeholderText: qsTr("Give this option a label")
                                                    text:modelData.label
                                                    onTextEdited: {target.fields[fieldRow.fieldIndex].values[index].label = text; lst.reload()}
                                                }
                                                TextField{
                                                    placeholderText: qsTr("Give this option a value")
                                                    text:modelData.value
                                                    onTextEdited: {
                                                        var num = Number(text)
                                                        if (typeof(num)=="number")
                                                            target.fields[fieldRow.fieldIndex].values[index].value = text;
                                                        else target.fields[fieldRow.fieldIndex].values[index].value = num;
                                                        lst.reload()}
                                                }
                                                FAButton{
                                                    icon:MaterialIcons.remove
                                                    decorate: false
                                                    onClicked:{target.fields[fieldRow.fieldIndex].values.splice(index,1); lst.reload()}
                                                    iconColor: "red"
                                                }

                                            }
                                        }
                                    }
                                }
                            }





                            FAButton{
                                Layout.alignment: Qt.AlignTop
                                icon:MaterialIcons.remove

                                onClicked:{target.fields.splice(index,1); lst.fieldsReloader++;}
                                text:qsTr("Remove field")
                                iconColor: "red"
                            }

                        }
                    }
                }
            }

            RowLayout{
                width:parent.width

                Row{
                    visible: lst.isData
                    height:parent.height
                    spacing: 5
                    Label{
                        height:parent.height
                        text:qsTr("Current row :")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    FAButton{
                        enabled:lst.currentIndex > 0
                        icon:MaterialIcons.keyboard_arrow_left
                        onClicked: lst.currentIndex = Math.max(0, lst.currentIndex-1)
                    }
                    Label{
                        id:tumbler
                        text:lst.currentIndex
                        height:parent.height
                        width:height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    FAButton{
                        enabled:lst.currentIndex < (target.lstModel.count -1)
                        icon:MaterialIcons.keyboard_arrow_right
                        onClicked: lst.currentIndex = Math.min(target.lstModel.count-1, lst.currentIndex+1)
                    }

                }

                FAButton{
                    icon:MaterialIcons.add_box
                    enabled: target.fields.length
                    onClicked:{
                        var newObj = {}
                        for (var i = 0; i < target.fields.length; i++)
                        {
                            var field = target.fields[i];

                            switch (field.type){
                            case DataElement.FieldType.ComboBox:
                                newObj[field.name]=0;//field.values[0].value;
                                break;
                            case DataElement.FieldType.Checkbox:
                                newObj[field.name]= false
                                break;
                            case DataElement.FieldType.TextField:
                                newObj[field.name]= ""
                                break;
                            }


                        }

                        target.lstModel.append(newObj);
                        lst.currentIndex = target.lstModel.count-1

                    }
                    iconColor: "green"
                    text:qsTr("Create Element")

                }

                FAButton{
                    icon:MaterialIcons.remove
                    visible:lst.isData
                    onClicked:{

                        target.lstModel.remove(lst.currentIndex);
                        lst.currentIndex = Math.min(target.lstModel.count-1, lst.currentIndex)
                    }
                    text:qsTr("Remove Element")
                    iconColor: "red"
                }
            }

            Component{
                id:comboBox
                RowLayout{
                    visible: lst.isData
                    Label{
                        text:currentField.name + " :"
                        Layout.minimumWidth: 100
                        color: Material.accent
                    }

                    ComboBox{
                        Layout.fillWidth: true
                        model: currentField.values
                        valueRole: "value"
                        textRole:"label"
                        //currentIndex : lst.fieldsReloader> 0 ? indexOfValue( lst.currentElement[currentField.name]) : -1
                        Component.onCompleted: currentIndex = Qt.binding(function(){ return indexOfValue( lst.currentElement[currentField.name])});
                        onActivated: target.lstModel.setProperty( lst.currentIndex, currentField.name, currentValue)
                    }
                }


            }
            Component{
                id:textField
                RowLayout{
                    Label{
                        text:currentField.name + " :"
                        Layout.minimumWidth: 100
                        color: Material.accent
                    }
                    TextField{
                        Layout.fillWidth: true
                        text:lst.isData ? lst.currentElement[currentField.name] : ""
                        placeholderText: qsTr(currentField.name)
                        onTextEdited: target.lstModel.setProperty( lst.currentIndex, currentField.name, text)
                    }
                }
            }
            Component{
                id:checkBox
                RowLayout{
                    visible: lst.isData
                    Label{
                        text:currentField.name + " :"
                        Layout.minimumWidth: 100
                        color: Material.accent
                    }
                    CheckBox{
                        //text:qsTr(currentField.name)
                        checked: lst.currentElement[currentField.name]
                        onToggled: target.lstModel.setProperty( lst.currentIndex, currentField.name, checked)
                    }
                    Item{ Layout.fillWidth: true}
                }
            }

            GroupBox{
                width:parent.width
                visible:lst.isData
                title:qsTr("Current selection")
                Column{
                    width:parent.width
                    Repeater{
                        id:repeater
                        model:fieldsReloader ? target.fields : target.fields
                        width:parent.width
                        delegate: Loader{
                            property var currentField : modelData
                            width:parent.width
                            sourceComponent:{
                                switch (modelData.type)
                                {
                                case DataElement.FieldType.ComboBox:
                                    return comboBox;
                                case DataElement.FieldType.TextField:
                                    return textField;
                                case DataElement.FieldType.CheckBox:
                                    return checkBox;
                                }

                            }

                        }
                    }
                }
            }
        }
    }


}
