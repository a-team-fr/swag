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
import QtDataVisualization 1.14
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0
import FontAwesome 1.0

Element {
    id: root
    property var dataSource:DataElement{}
    property var type : Abstract3DSeries.SeriesTypeBar
    property int theme : Theme3D.ThemeQt
    elementType: "DatavizElement"

    Component.onCompleted: {
        dumpedProperties.push({"name": "theme", "default": Theme3D.ThemeQt});
        //dumpedProperties.push({"name": "title", "default": ""});
        dumpedProperties.push({"name": "type", "default": Abstract3DSeries.SeriesTypeBar});
        dumpedProperties.push({"name": "dataSource", "default": []});
        dataSource.fields = [
                    {"name":"x", "type":DataElement.FieldType.TextField},
                    {"name":"y", "type":DataElement.FieldType.TextField},
                    {"name":"z", "type":DataElement.FieldType.TextField},
                    {"name":"label", "type":DataElement.FieldType.TextField},
                    {"name":"value", "type":DataElement.FieldType.TextField},
                    {"name":"values", "type":DataElement.FieldType.TextField}

            ]
        dataSource.fieldsModifiable = false

    }

    Theme3D{
        id:theTheme
        type:root.theme
    }

    Component{
        id:scatter
        Scatter3D {
            theme:theTheme
            Scatter3DSeries {
                ItemModelScatterDataProxy {
                    itemModel: root.dataSource.lstModel
                    xPosRole: "x";yPosRole: "y";zPosRole: "z"
                }
            }
        }
    }
    Component{
        id:bar
        Bars3D {
            theme:theTheme
            Bar3DSeries {
                itemLabelFormat: "@colLabel, @rowLabel: @valueLabel"

                ItemModelBarDataProxy {
                    itemModel: root.dataSource.lstModel
                    rowRole: "y"
                    columnRole: "x"
                    valueRole: "value"
                }
            }
        }
    }
    Component{
        id:surface
        Surface3D {
            theme:theTheme
            Surface3DSeries {
                itemLabelFormat: "Pop density at (@xLabel N, @zLabel E): @yLabel"
                ItemModelSurfaceDataProxy {
                    itemModel: root.dataSource.lstModel
                    rowRole: "y"
                    columnRole: "x"
                    yPosRole: "z"
                }
            }
        }
    }


    contentItem: Item {
        id:dataviz

        Loader{
            anchors.fill:parent
            sourceComponent:(root.type === Abstract3DSeries.SeriesTypeBar) ? bar : (root.type === Abstract3DSeries.SeriesTypeSurface) ? surface : scatter
        }

    }

    editorComponent: Component {
        Column {
            width:parent.width


            GroupBox{
                title:qsTr("theme")
                width:parent.width
                ComboBox{
                    anchors.fill:parent
                    textRole:"t";valueRole:"v"
                    model: [{v:Theme3D.ThemeQt, t:"ThemeQt"},
                        {v:Theme3D.ThemePrimaryColors, t:"ThemePrimaryColors"},
                        {v:Theme3D.ThemeDigia, t:"ThemeDigia"},
                        {v:Theme3D.ThemeStoneMoss, t:"ThemeStoneMoss"},
                        {v:Theme3D.ThemeArmyBlue, t:"ThemeArmyBlue"},
                        {v:Theme3D.ThemeRetro, t:"ThemeRetro"},
                        {v:Theme3D.ThemeEbony, t:"ThemeEbony"},
                        {v:Theme3D.ThemeIsabelle, t:"ThemeIsabelle"}
                    ]
                    //currentIndex: currentIndex = indexOfValue(target.theme)
                    Component.onCompleted: currentIndex = Qt.binding(function(){ return indexOfValue( target.theme)});
                    onActivated: target.theme = currentValue
                }
            }

            GroupBox{
                title:qsTr("type")
                width:parent.width
                ComboBox{
                    anchors.fill:parent
                    textRole:"t";valueRole:"v"
                    model: [
                        {v:Abstract3DSeries.SeriesTypeBar, t:"SeriesTypeBar"},
                        {v:Abstract3DSeries.SeriesTypeScatter, t:"SeriesTypeScatter"},
                        {v:Abstract3DSeries.SeriesTypeSurface, t:"SeriesTypeSurface"},
                    ]
                    //currentIndex: currentIndex = indexOfValue(target.type)
                    Component.onCompleted: currentIndex = Qt.binding(function(){ return indexOfValue( target.type)});
                    onActivated: target.type = currentValue
                }
            }


            GroupBox{
                title:qsTr("data")
                width:parent.width
                height:loadedDataElement.item.height + 50
                Loader{
                    id:loadedDataElement
                    width:parent.width
                    sourceComponent: dataSource.editorComponent
                    property var target : dataSource
                }
            }







        }
    }

}
