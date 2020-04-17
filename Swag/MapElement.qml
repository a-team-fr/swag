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
    property double centerLatitude: 47.096800
    property double centerLongitude: 1.636867
    property alias usePositionSource: positionSource.active
    property alias zoomLevel:content.zoomLevel
    property alias tilt:content.tilt
    property alias pluginName:mapPlugin.name
    property int activeMapTypeIndex:0

    elementType : "MapElement"

    Component.onCompleted: {
        dumpedProperties.push( {"name":"centerLatitude","default":43.777079})
        dumpedProperties.push( {"name":"centerLongitude","default":11.250628})
        dumpedProperties.push( {"name":"usePositionSource","default":false})
        dumpedProperties.push( {"name":"zoomLevel","default":0})
        dumpedProperties.push( {"name":"tilt","default":0})
        dumpedProperties.push( {"name":"pluginName","default":""})
        dumpedProperties.push( {"name":"activeMapTypeIndex","default":0})
    }

    PositionSource{
        id:positionSource
        active: false
        onPositionChanged: myMap.center = position.coordinate
        preferredPositioningMethods: PositionSource.AllPositioningMethods
    }

    Plugin {
              id: mapPlugin
              name: "osm"
          }


    contentItem:Map{
        id:content
        plugin:mapPlugin
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
            GroupBox{
                title:qsTr("centerLatitude")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.centerLatitude : ""
                    onEditingFinished: target.centerLatitude = Number(text)
                }
            }
            GroupBox{
                title:qsTr("centerLongitude")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.centerLongitude : ""
                    onEditingFinished: target.centerLongitude = Number(text)
                }
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
            GroupBox{
                title:qsTr("pluginName")
                width:parent.width
                ComboBox{
                    width:parent.width
                    model: ["osm", "esri", "mapboxgl"]
                    currentIndex: target ? currentIndex = indexOfValue(target.pluginName) : 0
                    onActivated: {
                        console.log(currentValue)
                        target.pluginName = currentValue
                    }
                }
            }
            GroupBox{
                width:parent.width
                title:qsTr("activeMapType")
                ComboBox{
                    width:parent.width
                    model: content.supportedMapTypes
                    textRole:"name"
                    currentIndex: target ? target.activeMapTypeIndex : 0
                    onCurrentIndexChanged: target.activeMapTypeIndex = currentIndex
                }
            }

        }
    }


}

