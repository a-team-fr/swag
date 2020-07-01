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
import QtQuick 2.12
import QtQuick.Controls 2.14



SplitView{
    id:coderenderer
    property alias showEditor : editor.visible
    property alias showRenderer : renderer.visible
    property alias style : editor.style
    property alias code : editor.code
    property alias langage : editor.langage
    property alias rendererSource : renderer.source
    property alias rendererComponent : renderer.sourceComponent
    property bool renderCode : true
    property alias showEditorPanel :editor.showEditorPanel
    property alias editorItem :editor
    property bool showSaveButton : false

    property alias renderedItem : renderer.item
    property bool clipRenderer : false

    signal saveButtonClicked()

    orientation: Qt.Horizontal

    CodeEditor{
        id:editor
        visible:false
        SplitView.preferredWidth: parent.width / 2
        SplitView.fillHeight: true
        showSaveButton: coderenderer.showSaveButton
        onSaveButtonClicked: coderenderer.saveButtonClicked()
    }

    Loader{
        id:renderer
        clip:coderenderer.clipRenderer
        SplitView.preferredWidth: parent.width / 2
        SplitView.fillHeight: true
        active : parent.visible

        sourceComponent: coderenderer.rendererSource ? Qt.createComponent(coderenderer.rendererSource) : undefined


        Label{
            text:qsTr("loading document...please wait")
            color : "green"
            opacity : 1 - renderer.progress
            anchors.centerIn: parent
            visible:renderer.status === Loader.Loading
        }
        TextArea{
            id:errorTxt
            text : (renderer.sourceComponent && renderer.status === Component.Error) ? renderer.sourceComponent.errorString() : ""
            wrapMode:Text.WordWrap
            color : "red"
            anchors.fill: parent
            visible:text.length
        }
    }

    property var renderedFromCode : null
    onCodeChanged: {
        if (renderCode)
        {
            if (renderedFromCode)
                renderedFromCode.destroy();

            try{
            renderedFromCode = Qt.createQmlObject( "import QtQuick 2.0;import QtQuick.Controls 2.5;import fr.ateam.swag 1.0;"+code, renderer, "renderedFromCode")
            }catch (error) {
                errorTxt.text = qsTr("Error in QML code when trying to create element :\n")
                   for (var i = 0; i < error.qmlErrors.length; i++) {
                       errorTxt.text += "message: " + error.qmlErrors[i].message +"\n"
                   }
               }
        }
    }



}
