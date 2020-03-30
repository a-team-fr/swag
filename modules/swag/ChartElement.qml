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
import QtCharts 2.3
import QtQuick.Layouts 1.3
import fr.ateam.swag 1.0
import FontAwesome 1.0

Element {
    id: root

    property alias theme : chartview.theme
    property alias title : chartview.title
    property var dataCharts:DataElement{}
    property var type : ChartView.SeriesTypeLine

    elementType: "ChartElement"

    Component.onCompleted: {
        dumpedProperties.push({"name": "theme", "default": ChartView.ChartThemeDark});
        dumpedProperties.push({"name": "title", "default": ""});
        dumpedProperties.push({"name": "type", "default": ChartView.SeriesTypeLine});

        dumpedProperties.push({"name": "dataCharts", "default": []});
        dataCharts.fields = [
                    {"name":"x", "type":DataElement.FieldType.TextField},
                    {"name":"y", "type":DataElement.FieldType.TextField},
                    {"name":"label", "type":DataElement.FieldType.TextField},
                    {"name":"value", "type":DataElement.FieldType.TextField},
                    {"name":"values", "type":DataElement.FieldType.TextField}

            ]
        dataCharts.fieldsModifiable = false
    }

    contentItem:ScrollView{
        id:scroll
        contentWidth: chartview.width
        contentHeight: chartview.height
        clip:true
        ChartView{
            id:chartview
            width:scroll.width
            height:scroll.height
            theme : ChartView.ChartThemeDark
            antialiasing: true
            title:"the chart title"

            axes: [
                ValueAxis{
                    id: xAxis
                    function add(val)
                    {
                        min = Math.min(min, val);
                        max = Math.max(max, val);
                    }

                    min: 10.0
                    max: -10.0
                },
                ValueAxis{
                    id: yAxis
                    function add(val)
                    {
                        min = Math.min(min, val);
                        max = Math.max(max, val);
                    }
                    min: 10.0
                    max: -10.0
                }
            ]

            Component.onCompleted: reload();

            function reload(){
                removeAllSeries();
                var serie = createSeries(root.type, "scatter series", xAxis, yAxis);
                serie.pointsVisible = true;
                for ( var pt = 0; pt < root.dataCharts.lstModel.count; pt++)
                {
                    var ptElem = root.dataCharts.lstModel.get(pt);
                    if ((root.type === ChartView.SeriesTypeLine) ||
                            (root.type === ChartView.SeriesTypeSpline) ||
                            //(root.type === ChartView.SeriesTypeArea) ||
                            (root.type === ChartView.SeriesTypeScatter)
                            )
                    {
                        serie.append(Number(ptElem.x), Number(ptElem.y) );
                        xAxis.add( Number(ptElem.x));
                        yAxis.add( Number(ptElem.y));
                    }
                    else if ((root.type === ChartView.SeriesTypePie)
                             )
                    {
                        serie.append(ptElem.label, ptElem.value );
                        xAxis.add( Number(ptElem.value));
                        yAxis.add( Number(ptElem.value));
                    }
                    /*else if ((root.type === ChartView.SeriesTypeBoxPlot) ||
                             (root.type === ChartView.SeriesTypeBar) ||
                             (root.type === ChartView.SeriesTypeStackedBar) ||
                             (root.type === ChartView.SeriesTypePercentBar) ||
                             (root.type === ChartView.SeriesTypeHorizontalBar) ||
                             (root.type === ChartView.SeriesTypeHorizontalStackedBar) ||
                             (root.type === ChartView.HorizontalPercentBar)
                             )
                        serie.append(ptElem.label, ptElem.values );
                        */
                }

            }
        }
        FAButton{
            onClicked: chartview.zoomOut()
            text:"-"
        }
        FAButton{
            onClicked: chartview.zoomIn()
            text:"+"
            anchors.right:parent.right
        }
    }


    editorComponent: Component {
        Column {
            width:parent.width
            GroupBox{
                title:qsTr("title")
                width:parent.width
                TextField{
                    anchors.fill:parent
                    text:target ? target.title : ""
                    onEditingFinished: target.title = text
                }
            }

            GroupBox{
                title:qsTr("theme")
                width:parent.width
                ComboBox{
                    anchors.fill:parent
                    textRole:"t";valueRole:"v"
                    model: [{v:ChartView.ChartThemeLight, t:"ChartThemeLight"},
                        {v:ChartView.ChartThemeBlueCerulean, t:"ChartThemeBlueCerulean"},
                        {v:ChartView.ChartThemeDark, t:"ChartThemeDark"},
                        {v:ChartView.ChartThemeBrownSand, t:"ChartThemeBrownSand"},
                        {v:ChartView.ChartThemeBlueNcs, t:"ChartThemeBlueNcs"},
                        {v:ChartView.ChartThemeHighContrast, t:"ChartThemeHighContrast"},
                        {v:ChartView.ChartThemeBlueIcy, t:"ChartThemeBlueIcy"},
                        {v:ChartView.ChartThemeQt, t:"ChartThemeQt"}
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
//                        {v:ChartView.SeriesTypeArea, t:"Area"},
                        {v:ChartView.SeriesTypePie, t:"Pie"},
                        {v:ChartView.SeriesTypeLine, t:"Line"},
//                        {v:ChartView.SeriesTypeBar, t:"Bar"},
//                        {v:ChartView.SeriesTypeHorizontalBar, t:"HorizontalBar"},
//                        {v:ChartView.SeriesTypeHorizontalStackedBar, t:"HorizontalStackedBar"},
//                        {v:ChartView.SeriesTypeHorizontalPercentBar, t:"HorizontalPercentBar"},
//                        {v:ChartView.SeriesTypeStackedBar, t:"StackedBar"},
//                        {v:ChartView.SeriesTypePercentBar, t:"PercentBar"},
                        {v:ChartView.SeriesTypeSpline, t:"Spline"},
                        {v:ChartView.SeriesTypeScatter, t:"Scatter"},
//                        {v:ChartView.SeriesTypeBoxPlot, t:"Box"},
//                        {v:ChartView.SeriesTypeCandlestick, t:"Candlestick"}
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
                    sourceComponent: dataCharts.editorComponent
                    property var target : dataCharts
                }
            }







        }
    }
}
