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
import fr.ateam.swag 1.0
import QtQuick.Controls 2.12
import Qt3D.Core 2.14
import Qt3D.Render 2.14
import Qt3D.Input 2.14
import Qt3D.Logic 2.14
import Qt3D.Extras 2.14
import Qt3D.Animation 2.14
import QtQuick.Scene2D 2.14
import QtQuick.Scene3D 2.14

Element {
    id: root

    elementType: "Entity3DElement"

    property string meshPath : ""
    property real rollAngle: 0
    property real pitchAngle: 0
    property real altitude: 0
    property real heading: 0
    property real scaleFactor: 1
    property color clearColor : Qt.rgba(0, 0.0, 0, 0)
    property alias position: camera.position
    property alias upVector: camera.upVector
    property alias viewCenter: camera.position

    Component.onCompleted: {
        dumpedProperties.push({"name": "meshPath", "default": ""});
        dumpedProperties.push({"name": "rollAngle", "default": 0});
        dumpedProperties.push({"name": "pitchAngle", "default": 0});
        dumpedProperties.push({"name": "altitude", "default": 0});
        dumpedProperties.push({"name": "heading", "default": 0});
        dumpedProperties.push({"name": "scaleFactor", "default": 1});
        dumpedProperties.push({"name": "clearColor", "default": Qt.rgba(0, 0.0, 0, 0)});
        dumpedProperties.push({"name": "position", "default": Qt.vector3d( 0.0, 0.0, 40.0 ), "dumpFunction":dump3DVector});
        dumpedProperties.push({"name": "upVector", "default": Qt.vector3d( 0.0, 1.0, 0.0), "dumpFunction":dump3DVector});
        dumpedProperties.push({"name": "viewCenter", "default": Qt.vector3d( 0.0, 0.0, 0.0 ), "dumpFunction":dump3DVector});
    }


    SlideDumper{
        id:dump
    }

    function dump3DVector(object,rank, prop)
    {
        dump.slideDump="";
        dump.addTabulation( rank);
        dump.slideDump += prop["name"] + ": Qt.vector3d("+object[prop.name].x+", "+object[prop.name].y+", "+object[prop.name].z+");\n";
        return dump.slideDump;
    }

    contentItem: NavMan.settings.loadElement3d ? cmp3d : fallback
    property var fallback : Label{ color:"red"; anchors.fill:parent; text: qsTr("Entity3dElement disabled (known issues reported), you can override from the settings")}
    property var cmp3d : Scene3D {
        id: scene3d
        focus: true
        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio


        Entity {
            id: sceneRoot

            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                aspectRatio: 16/9
                nearPlane : 0.1
                farPlane : 1000.0
                position: Qt.vector3d( 0.0, 0.0, 40.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
            }

            OrbitCameraController { camera: camera }

            components: [
                RenderSettings {
                    activeFrameGraph: ForwardRenderer {
                        camera: camera
                        clearColor: root.clearColor
                    }
                },
                InputSettings { }
            ]

            PhongMaterial {
                id: material
            }

            Mesh {
                id: mesh
                source: pm.lookForLocalFile(root.meshPath)
                //onSourceChanged: console.log(source)
            }

            Transform {
                id: transform

                matrix: {
                    var m = Qt.matrix4x4();
                    m.translate(Qt.vector3d(Math.sin(root.heading * Math.PI / 180) * root.scaleFactor,
                                            root.altitude,
                                            Math.cos(root.heading * Math.PI / 180) * root.scaleFactor));
                    m.rotate(root.heading, Qt.vector3d(0, 1, 0));
                    m.rotate(root.pitchAngle, Qt.vector3d(0, 0, 1));
                    m.rotate(root.rollAngle, Qt.vector3d(1, 0, 0));
                    m.scale(1.0 / root.scaleFactor);
                    return m;
                }
            }

            Entity {
                components: [ mesh, material, transform ]
            }
        }
    }

    editorComponent: Component {
        Column {
            width:parent.width

            GroupBox{
                title:qsTr("meshPath")
                width:parent.width
                TextField{
                    width:parent.width
                    text:target ? target.meshPath : ""
                    onTextEdited: target.meshPath = text
                    onEditingFinished: target.meshPath = text
                }
            }
        }
    }
}
