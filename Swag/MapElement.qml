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
import QtLocation 5.12
import QtPositioning 5.12

Element{
    id:root
    height : 480
    width : 640
    property double centerLatitude: 47.096800
    property double centerLongitude: 1.636867
    property alias usePositionSource: positionSource.active
    property alias zoomLevel:content.zoomLevel
    property alias tilt:content.tilt
    property alias pluginName:content.plugin.name //mapPlugin.name
    property int activeMapTypeIndex:0

    elementType : "MapElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"centerLatitude","default":43.777079})
        dumpedProperties.push( {"name":"centerLongitude","default":11.250628})
        dumpedProperties.push( {"name":"usePositionSource","default":false})
        dumpedProperties.push( {"name":"zoomLevel","default":0})
        dumpedProperties.push( {"name":"tilt","default":0})
        dumpedProperties.push( {"name":"pluginName","default":"esri"})
        dumpedProperties.push( {"name":"activeMapTypeIndex","default":0})
    }

    PositionSource{
        id:positionSource
        active: false
        onPositionChanged: myMap.center = position.coordinate
        preferredPositioningMethods: PositionSource.AllPositioningMethods
    }



    contentItem:Map{
        id:content
        plugin:Plugin {
            name: "esri"
        }
        center : QtPositioning.coordinate(root.centerLatitude, root.centerLongitude)
        onCenterChanged: {
            root.centerLatitude = center.latitude
            root.centerLongitude = center.longitude
        }
    }

    editorComponent:Component{
        Column{
            width:parent.width
            spacing :3
            FormItem{
                title:qsTr("centerLatitude")
                width:parent.width
                text:target.centerLatitude
                onEditingFinished: target.centerLatitude = Number(text)

            }
            FormItem{
                title:qsTr("centerLongitude")
                width:parent.width
                text:target.centerLongitude
                onEditingFinished: target.centerLongitude = Number(text)

            }
            SwitchDelegate{
                text:qsTr("usePositionSource")
                width:parent.width
                checked:target ? target.usePositionSource : false
                onCheckableChanged: target.usePositionSource = checked
            }
            GroupBox{
                title:qsTr("zoomLevel")
                width:parent.width
                Slider{
                    width:parent.width
                    from:content.minimumZoomLevel
                    to:content.maximumZoomLevel
                    onValueChanged:target.zoomLevel = value
                }
            }
            GroupBox{
                title:qsTr("tilt")
                width:parent.width
                Slider{
                    width:parent.width
                    from:content.minimumTilt
                    to:content.maximumTilt
                    onValueChanged:target.tilt = value
                }
            }
//            FormItem{
//                title:qsTr("pluginName")
//                width:parent.width
//                    comboBox.model: ["osm", "esri", "mapboxgl"]
//                    comboBox.currentIndex: comboBox.indexOfValue(target.pluginName)
//                    onActivated: {
//                        console.log(comboBox.currentValue)
//                        target.pluginName = comboBox.currentValue
//                        target.activeMapTypeIndex = 0
//                    }

//            }
            FormItem{
                width:parent.width
                title:qsTr("activeMapType")
                comboBox.model: content.supportedMapTypes
                comboBox.textRole:"name"
                comboBox.currentIndex: target.activeMapTypeIndex
                onCurrentTextChanged: target.activeMapTypeIndex = comboBox.currentIndex

            }

        }
    }


}

