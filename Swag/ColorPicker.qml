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
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
//import QtQuick.Dialogs 1.2
import MaterialIcons 1.0
import fr.ateam.swag 1.0
//import Swag 1.0

Dialog{
    id:root
    implicitHeight : 500
    implicitWidth : 500

    title:qsTr("Color picker")
    anchors.centerIn : parent
    standardButtons: Dialog.Ok | Dialog.Reset
    property color currentColor : "transparent"
    property string currentColorName : "transparent"
    property bool closeAtSelection : false

    signal selected()
    modal:true
    onReset: {
        root.currentColor = "transparent"
        root.currentColorName = "transparent"
        root.selected();
        close()
    }

    Column{
        anchors.fill:parent


        TabBar {
            id: bar
            width: parent.width
            TabButton {
                text: qsTr("List")
            }
            TabButton {
                text: qsTr("Custom")
            }
        }


        StackLayout {
            width: parent.width
            height : parent.height - bar.height
            currentIndex: bar.currentIndex
            Item {
                id: listTab

                RowLayout{
                    id:groupListSelect
                    readonly property string name : lstGroup[ selected ].v
                    property int selected : 0
                    property var lstGroup : [ {"l":"All", "v":""}, {"l":"Standard", "v":"svg name"}, {"l":"Dark", "v":"dark"}, {"l":"Light", "v":"light"}]
                    Label{ text:qsTr("color group :") }
                    Repeater{
                        model:parent.lstGroup
                        delegate: Button{
                            text: modelData.l
                            checked: groupListSelect.index === index
                            onClicked: groupListSelect.selected = index
                        }
                    }
                }


                ScrollView{
                    id : scroll
                    anchors.fill:parent
                    anchors.topMargin : groupListSelect.height
                    anchors.margins: 5
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    clip : true
                    Flow{
                        width:scroll.width
                        spacing : 5
                        Repeater{
                            model: lstMaterialColor
                            delegate: FAButton{
                                //icon : MaterialIcons.stop
                                backgroundColor: model.v
                                backgroundHoveredColor : Qt.lighter(model.v)
                                ToolTip.visible: hovered
                                ToolTip.text : model.l
                                visible : (groupListSelect.name.length === 0) || (groupListSelect.name === model.group)
                                onClicked: {
                                    root.currentColor = model.v
                                    root.currentColorName = model.l
                                    if (root.closeAtSelection)
                                        root.close()
                                    root.selected();
                                }
                                onDoubleClicked : {
                                    root.currentColor = model.v
                                    root.currentColorName = model.l
                                    root.close()
                                    root.selected();
                                }
                            }
                        }
                    }


                }
            }
            Row{
                spacing : 10
                ColumnLayout{
                    height:parent.height; width : parent.width / 2
                    Slider{
                        id:red
                        //title:"Red"
                        value : root.currentColor.r
                        onMoved:{ root.currentColor = Qt.rgba( red.value, green.value, blue.value, alpha.value); root.selected(); }
                    }
                    Slider{
                        id:green
                        value : root.currentColor.g
                        onMoved:{ root.currentColor = Qt.rgba( red.value, green.value, blue.value, alpha.value); root.selected(); }

                    }
                    Slider{
                        id:blue
                        value : root.currentColor.b
                        onMoved:{ root.currentColor = Qt.rgba( red.value, green.value, blue.value, alpha.value); root.selected(); }
                    }
                    Slider{
                        id:alpha
                        value : root.currentColor.a
                        onMoved:{ root.currentColor = Qt.rgba( red.value, green.value, blue.value, alpha.value); root.selected(); }
                    }
                    TextField{
                        text: root.currentColor
                        onEditingFinished: { root.currentColor = text; root.selected(); }
                    }
                }
                GroupBox{
                    title:qsTr("Resulting color")
                    height:parent.height; width : parent.width / 2
                    Rectangle{
                        anchors.centerIn : parent
                        height:Math.min(parent.width, parent.height)*0.8; width : height
                        color: root.currentColor
                    }
                }
            }
        }



    }




    ListModel{
        id:lstMaterialColor
        ListElement{ v:"#f0f8ff"; l:"aliceblue"; group:"svg name"}
        ListElement{ v:"#faebd7"; l:"antiquewhite"; group:"svg name"}
        ListElement{ v:"#00ffff"; l:"aqua"; group:"svg name"}
        ListElement{ v:"#7fffd4"; l:"aquamarine"; group:"svg name"}
        ListElement{ v:"#f0ffff"; l:"azure"; group:"svg name"}
        ListElement{ v:"#f5f5dc"; l:"beige"; group:"svg name"}
        ListElement{ v:"#ffe4c4"; l:"bisque"; group:"svg name"}
        ListElement{ v:"#000000"; l:"black"; group:"svg name"}
        ListElement{ v:"#ffebcd"; l:"blanchedalmond"; group:"svg name"}
        ListElement{ v:"#0000ff"; l:"blue"; group:"svg name"}
        ListElement{ v:"#8a2be2"; l:"blueviolet"; group:"svg name"}
        ListElement{ v:"#a52a2a"; l:"brown"; group:"svg name"}
        ListElement{ v:"#deb887"; l:"burlywood"; group:"svg name"}
        ListElement{ v:"#5f9ea0"; l:"cadetblue"; group:"svg name"}
        ListElement{ v:"#7fff00"; l:"chartreuse"; group:"svg name"}
        ListElement{ v:"#d2691e"; l:"chocolate"; group:"svg name"}
        ListElement{ v:"#ff7f50"; l:"coral"; group:"svg name"}
        ListElement{ v:"#6495ed"; l:"cornflowerblue"; group:"svg name"}
        ListElement{ v:"#fff8dc"; l:"cornsilk"; group:"svg name"}
        ListElement{ v:"#dc143c"; l:"crimson"; group:"svg name"}
        ListElement{ v:"#00ffff"; l:"cyan"; group:"svg name"}
        ListElement{ v:"#00008b"; l:"darkblue"; group:"svg name"}
        ListElement{ v:"#008b8b"; l:"darkcyan"; group:"svg name"}
        ListElement{ v:"#b8860b"; l:"darkgoldenrod"; group:"svg name"}
        ListElement{ v:"#a9a9a9"; l:"darkgray"; group:"svg name"}
        ListElement{ v:"#006400"; l:"darkgreen"; group:"svg name"}
        ListElement{ v:"#a9a9a9"; l:"darkgrey"; group:"svg name"}
        ListElement{ v:"#bdb76b"; l:"darkkhaki"; group:"svg name"}
        ListElement{ v:"#8b008b"; l:"darkmagenta"; group:"svg name"}
        ListElement{ v:"#556b2f"; l:"darkolivegreen"; group:"svg name"}
        ListElement{ v:"#ff8c00"; l:"darkorange"; group:"svg name"}
        ListElement{ v:"#9932cc"; l:"darkorchid"; group:"svg name"}
        ListElement{ v:"#8b0000"; l:"darkred"; group:"svg name"}
        ListElement{ v:"#e9967a"; l:"darksalmon"; group:"svg name"}
        ListElement{ v:"#8fbc8f"; l:"darkseagreen"; group:"svg name"}
        ListElement{ v:"#483d8b"; l:"darkslateblue"; group:"svg name"}
        ListElement{ v:"#2f4f4f"; l:"darkslategray"; group:"svg name"}
        ListElement{ v:"#2f4f4f"; l:"darkslategrey"; group:"svg name"}
        ListElement{ v:"#00ced1"; l:"darkturquoise"; group:"svg name"}
        ListElement{ v:"#9400d3"; l:"darkviolet"; group:"svg name"}
        ListElement{ v:"#ff1493"; l:"deeppink"; group:"svg name"}
        ListElement{ v:"#00bfff"; l:"deepskyblue"; group:"svg name"}
        ListElement{ v:"#696969"; l:"dimgray"; group:"svg name"}
        ListElement{ v:"#696969"; l:"dimgrey"; group:"svg name"}
        ListElement{ v:"#1e90ff"; l:"dodgerblue"; group:"svg name"}
        ListElement{ v:"#b22222"; l:"firebrick"; group:"svg name"}
        ListElement{ v:"#fffaf0"; l:"floralwhite"; group:"svg name"}
        ListElement{ v:"#228b22"; l:"forestgreen"; group:"svg name"}
        ListElement{ v:"#ff00ff"; l:"fuchsia"; group:"svg name"}
        ListElement{ v:"#dcdcdc"; l:"gainsboro"; group:"svg name"}
        ListElement{ v:"#f8f8ff"; l:"ghostwhite"; group:"svg name"}
        ListElement{ v:"#ffd700"; l:"gold"; group:"svg name"}
        ListElement{ v:"#daa520"; l:"goldenrod"; group:"svg name"}
        ListElement{ v:"#808080"; l:"gray"; group:"svg name"}
        ListElement{ v:"#808080"; l:"grey"; group:"svg name"}
        ListElement{ v:"#008000"; l:"green"; group:"svg name"}
        ListElement{ v:"#adff2f"; l:"greenyellow"; group:"svg name"}
        ListElement{ v:"#f0fff0"; l:"honeydew"; group:"svg name"}
        ListElement{ v:"#ff69b4"; l:"hotpink"; group:"svg name"}
        ListElement{ v:"#cd5c5c"; l:"indianred"; group:"svg name"}
        ListElement{ v:"#4b0082"; l:"indigo"; group:"svg name"}
        ListElement{ v:"#fffff0"; l:"ivory"; group:"svg name"}
        ListElement{ v:"#f0e68c"; l:"khaki"; group:"svg name"}
        ListElement{ v:"#e6e6fa"; l:"lavender"; group:"svg name"}
        ListElement{ v:"#fff0f5"; l:"lavenderblush"; group:"svg name"}
        ListElement{ v:"#7cfc00"; l:"lawngreen"; group:"svg name"}
        ListElement{ v:"#fffacd"; l:"lemonchiffon"; group:"svg name"}
        ListElement{ v:"#add8e6"; l:"lightblue"; group:"svg name"}
        ListElement{ v:"#f08080"; l:"lightcoral"; group:"svg name"}
        ListElement{ v:"#e0ffff"; l:"lightcyan"; group:"svg name"}
        ListElement{ v:"#fafad2"; l:"lightgoldenrodyellow"; group:"svg name"}
        ListElement{ v:"#d3d3d3"; l:"lightgray"; group:"svg name"}
        ListElement{ v:"#90ee90"; l:"lightgreen"; group:"svg name"}
        ListElement{ v:"#d3d3d3"; l:"lightgrey"; group:"svg name"}
        ListElement{ v:"#ffb6c1"; l:"lightpink"; group:"svg name"}
        ListElement{ v:"#ffa07a"; l:"lightsalmon"; group:"svg name"}
        ListElement{ v:"#20b2aa"; l:"lightseagreen"; group:"svg name"}
        ListElement{ v:"#87cefa"; l:"lightskyblue"; group:"svg name"}
        ListElement{ v:"#778899"; l:"lightslategray"; group:"svg name"}
        ListElement{ v:"#778899"; l:"lightslategrey"; group:"svg name"}
        ListElement{ v:"#b0c4de"; l:"lightsteelblue"; group:"svg name"}
        ListElement{ v:"#ffffe0"; l:"lightyellow"; group:"svg name"}
        ListElement{ v:"#00ff00"; l:"lime"; group:"svg name"}
        ListElement{ v:"#32cd32"; l:"limegreen"; group:"svg name"}
        ListElement{ v:"#faf0e6"; l:"linen"; group:"svg name"}
        ListElement{ v:"#ff00ff"; l:"magenta"; group:"svg name"}
        ListElement{ v:"#800000"; l:"maroon"; group:"svg name"}
        ListElement{ v:"#66cdaa"; l:"mediumaquamarine"; group:"svg name"}
        ListElement{ v:"#0000cd"; l:"mediumblue"; group:"svg name"}
        ListElement{ v:"#ba55d3"; l:"mediumorchid"; group:"svg name"}
        ListElement{ v:"#9370db"; l:"mediumpurple"; group:"svg name"}
        ListElement{ v:"#3cb371"; l:"mediumseagreen"; group:"svg name"}
        ListElement{ v:"#7b68ee"; l:"mediumslateblue"; group:"svg name"}
        ListElement{ v:"#00fa9a"; l:"mediumspringgreen"; group:"svg name"}
        ListElement{ v:"#48d1cc"; l:"mediumturquoise"; group:"svg name"}
        ListElement{ v:"#c71585"; l:"mediumvioletred"; group:"svg name"}
        ListElement{ v:"#191970"; l:"midnightblue"; group:"svg name"}
        ListElement{ v:"#f5fffa"; l:"mintcream"; group:"svg name"}
        ListElement{ v:"#ffe4e1"; l:"mistyrose"; group:"svg name"}
        ListElement{ v:"#ffe4b5"; l:"moccasin"; group:"svg name"}
        ListElement{ v:"#ffdead"; l:"navajowhite"; group:"svg name"}
        ListElement{ v:"#000080"; l:"navy"; group:"svg name"}
        ListElement{ v:"#fdf5e6"; l:"oldlace"; group:"svg name"}
        ListElement{ v:"#808000"; l:"olive"; group:"svg name"}
        ListElement{ v:"#6b8e23"; l:"olivedrab"; group:"svg name"}
        ListElement{ v:"#ffa500"; l:"orange"; group:"svg name"}
        ListElement{ v:"#ff4500"; l:"orangered"; group:"svg name"}
        ListElement{ v:"#da70d6"; l:"orchid"; group:"svg name"}
        ListElement{ v:"#eee8aa"; l:"palegoldenrod"; group:"svg name"}
        ListElement{ v:"#98fb98"; l:"palegreen"; group:"svg name"}
        ListElement{ v:"#afeeee"; l:"paleturquoise"; group:"svg name"}
        ListElement{ v:"#db7093"; l:"palevioletred"; group:"svg name"}
        ListElement{ v:"#ffefd5"; l:"papayawhip"; group:"svg name"}
        ListElement{ v:"#ffdab9"; l:"peachpuff"; group:"svg name"}
        ListElement{ v:"#cd853f"; l:"peru"; group:"svg name"}
        ListElement{ v:"#ffc0cb"; l:"pink"; group:"svg name"}
        ListElement{ v:"#dda0dd"; l:"plum"; group:"svg name"}
        ListElement{ v:"#b0e0e6"; l:"powderblue"; group:"svg name"}
        ListElement{ v:"#800080"; l:"purple"; group:"svg name"}
        ListElement{ v:"#ff0000"; l:"red"; group:"svg name"}
        ListElement{ v:"#bc8f8f"; l:"rosybrown"; group:"svg name"}
        ListElement{ v:"#4169e1"; l:"royalblue"; group:"svg name"}
        ListElement{ v:"#8b4513"; l:"saddlebrown"; group:"svg name"}
        ListElement{ v:"#fa8072"; l:"salmon"; group:"svg name"}
        ListElement{ v:"#f4a460"; l:"sandybrown"; group:"svg name"}
        ListElement{ v:"#2e8b57"; l:"seagreen"; group:"svg name"}
        ListElement{ v:"#fff5ee"; l:"seashell"; group:"svg name"}
        ListElement{ v:"#a0522d"; l:"sienna"; group:"svg name"}
        ListElement{ v:"#c0c0c0"; l:"silver"; group:"svg name"}
        ListElement{ v:"#87ceeb"; l:"skyblue"; group:"svg name"}
        ListElement{ v:"#6a5acd"; l:"slateblue"; group:"svg name"}
        ListElement{ v:"#708090"; l:"slategray"; group:"svg name"}
        ListElement{ v:"#708090"; l:"slategrey"; group:"svg name"}
        ListElement{ v:"#fffafa"; l:"snow"; group:"svg name"}
        ListElement{ v:"#00ff7f"; l:"springgreen"; group:"svg name"}
        ListElement{ v:"#4682b4"; l:"steelblue"; group:"svg name"}
        ListElement{ v:"#d2b48c"; l:"tan"; group:"svg name"}
        ListElement{ v:"#008080"; l:"teal"; group:"svg name"}
        ListElement{ v:"#d8bfd8"; l:"thistle"; group:"svg name"}
        ListElement{ v:"#ff6347"; l:"tomato"; group:"svg name"}
        ListElement{ v:"#40e0d0"; l:"turquoise"; group:"svg name"}
        ListElement{ v:"#ee82ee"; l:"violet"; group:"svg name"}
        ListElement{ v:"#f5deb3"; l:"wheat"; group:"svg name"}
        ListElement{ v:"#ffffff"; l:"white"; group:"svg name"}
        ListElement{ v:"#f5f5f5"; l:"whitesmoke"; group:"svg name"}
        ListElement{ v:"#ffff00"; l:"yellow"; group:"svg name"}
        ListElement{ v:"#9acd32"; l:"yellowgreen"; group:"svg name"}


        ListElement{ v:"#303030"; l:"background(dark)"; group:"dark"}
        ListElement{ v:"#EF9A9A"; l:"Red (dark)"; group:"dark"}
        ListElement{ v:"#F48FB1"; l:"Pink (dark)"; group:"dark"}
        ListElement{ v:"#CE93D8"; l:"Purple (dark)"; group:"dark"}
        ListElement{ v:"#B39DDB"; l:"DeepPurple (dark)"; group:"dark"}
        ListElement{ v:"#9FA8DA"; l:"Indigo (dark)"; group:"dark"}
        ListElement{ v:"#90CAF9"; l:"Blue (dark)"; group:"dark"}
        ListElement{ v:"#81D4FA"; l:"LightBlue (dark)"; group:"dark"}
        ListElement{ v:"#80DEEA"; l:"Cyan (dark)"; group:"dark"}
        ListElement{ v:"#80CBC4"; l:"Teal (dark)"; group:"dark"}
        ListElement{ v:"#A5D6A7"; l:"Green (dark)"; group:"dark"}
        ListElement{ v:"#C5E1A5"; l:"LightGreen (dark)"; group:"dark"}
        ListElement{ v:"#E6EE9C"; l:"Lime (dark)"; group:"dark"}
        ListElement{ v:"#FFF59D"; l:"Yellow (dark)"; group:"dark"}
        ListElement{ v:"#FFE082"; l:"Amber (dark)"; group:"dark"}
        ListElement{ v:"#FFCC80"; l:"Orange (dark)"; group:"dark"}
        ListElement{ v:"#FFAB91"; l:"DeepOrange (dark)"; group:"dark"}
        ListElement{ v:"#BCAAA4"; l:"Brown (dark)"; group:"dark"}
        ListElement{ v:"#EEEEEE"; l:"Grey (dark)"; group:"dark"}
        ListElement{ v:"#B0BEC5"; l:"BlueGrey (dark)"; group:"dark"}

        ListElement{ v:"#CFCFCF"; l:"background(light)"; group:"light"}
        ListElement{ v:"#F44336"; l:"Red (light)"; group:"light"}
        ListElement{ v:"#E91E63"; l:"Pink (light)"; group:"light"}
        ListElement{ v:"#9C27B0"; l:"Purple (light)"; group:"light"}
        ListElement{ v:"#673AB7"; l:"DeepPurple (light)"; group:"light"}
        ListElement{ v:"#3F51B5"; l:"Indigo (light)"; group:"light"}
        ListElement{ v:"#2196F3"; l:"Blue (light)"; group:"light"}
        ListElement{ v:"#03A9F4"; l:"LightBlue (light)"; group:"light"}
        ListElement{ v:"#00BCD4"; l:"Cyan (light)"; group:"light"}
        ListElement{ v:"#009688"; l:"Teal (light)"; group:"light"}
        ListElement{ v:"#4CAF50"; l:"Green (light)"; group:"light"}
        ListElement{ v:"#8BC34A"; l:"LightGreen (light)"; group:"light"}
        ListElement{ v:"#CDDC39"; l:"Lime (light)"; group:"light"}
        ListElement{ v:"#FFEB3B"; l:"Yellow (light)"; group:"light"}
        ListElement{ v:"#FFC107"; l:"Amber (light)"; group:"light"}
        ListElement{ v:"#FF9800"; l:"Orange (light)"; group:"light"}
        ListElement{ v:"#FF5722"; l:"DeepOrange (light)"; group:"light"}
        ListElement{ v:"#795548"; l:"Brown (light)"; group:"light"}
        ListElement{ v:"#9E9E9E"; l:"Grey (light)"; group:"light"}
        ListElement{ v:"#607D8B"; l:"BlueGrey (light)"; group:"light"}


    }

}
