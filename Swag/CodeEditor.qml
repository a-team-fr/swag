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
import QtQuick 2.0
import QtQuick.Controls 2.5
import MaterialIcons 1.0

Rectangle {
    id: content
    property string langage: "qml"
    property string code: ""
    property alias enabled : editor.enabled
    property string style: "darcula"
    property alias showEditorPanel : editorPanel.visible
    property bool showLineNumber : true
    property alias contentHeight: editor.contentHeight

    property string hljsRootDir: "file:" + pm.installPath + "/deps"

    property bool showSaveButton : false

    property var hightlighter: pm.installPath.length && Qt.createQmlObject(
                                   'import QtQuick 2.0;
import "' + hljsRootDir + '/hljs/highlight.js" as HLJS;
import "' + hljsRootDir + '/hljs/languages/' + langage + '.js" as LANG;
QtObject {
property var hljs: {
var tmp = HLJS.hljs();
tmp.registerLanguage( "' + langage + '", LANG.register );
return tmp
}
}
', parent)

    signal editingFinish()
    signal saveButtonClicked()

    implicitHeight: 200
    implicitWidth: 300
    Row{
        id:editorPanel
        width : parent.width
        height : visible ? 45 : 0
        visible:false
        ComboBox{
            model:["androidstudio","atom-one-dark","github","darcula","qtcreator_light", "qtcreator_dark","vs","typescript"]
            displayText: content.style
            onActivated: content.style = currentText
            height:editorPanel.height
            width:parent.width/2
        }
        ComboBox{
            model:["cpp","dart","delphi", "javascript","json","glsl", "qml","xml","markdown"]
            displayText: content.langage
            onActivated: content.langage = currentText
            height:editorPanel.height
            width:parent.width/2
        }
    }
    FAButton{
        y:editorPanel.height
        anchors.right : parent.right
        icon:MaterialIcons.save
        width:30;height:width
        visible:content.showSaveButton
        z:1
        onClicked: {
            content.code = editor.getText(0, editor.length)
            content.saveButtonClicked()
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.topMargin: editorPanel.height
        contentWidth:width
        contentHeight:editor.contentHeight + 50
        ScrollBar.vertical.x : 0
        clip : true

        Row {
            anchors.fill: parent
            Item {
                id:lineNumber
                visible : content.showLineNumber
                width: visible ? 45 : 0
                height: parent.height
                Repeater {
                    model: editor.lineCount
                    delegate: Label {
                        x: 5
                        y: 10 + (index * height)
                        width: 25
                        height: (editor.contentHeight) / (editor.lineCount)
                        text: index + 1
                        //readOnly: true
                        color: "grey"
                        horizontalAlignment: Text.AlignRight
                        font: editor.font
                    }
                }
            }

            TextArea {
                id: editor
                width: parent.width - lineNumber.width
                height: parent.height
                text: content.code2Html(content.langage, content.code,content.css)
                wrapMode: Text.WordWrap
                selectByMouse: true
                textFormat: TextEdit.RichText
                inputMethodHints: Qt.ImhNoPredictiveText
                onEditingFinished: {
                    content.code = getText(0, length)
                    content.editingFinish()
                }
                onPressed:content.code = getText(0, length)
            }
        }
    }

    property string css: pm ? pm.readDocument(
                                  pm.installPath + "/deps/hljs/styles/"
                                  + style + ".css") : ""
    color: {
        /background:\s*([#1-9a-zA-Z].+?);/g.exec(css)[1]
    }

    function code2Html(langage, codeToConvert, cssToUse) {
        if (!hightlighter)
            return
        var html = hightlighter.hljs.highlight(langage, codeToConvert).value
        html = html.split("\u2028").join("<br/>\u2028").split("\n").join(
                    "<br/>\u2028").split("  ").join(" &nbsp;")
        return "<style>" + cssToUse + "</style>" + "<span class='hljs'>" + html + "</span>"
    }
}
