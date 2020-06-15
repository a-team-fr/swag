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
import QtQuick.Layouts 1.0
import fr.ateam.swag 1.0
import Swag 1.0

Frame{
    id:root
    width:parent.width * 0.5
    height:lstView.contentHeight + 30

    visible: lstFileTransfering.count
    background:Rectangle{
        color:"darkgrey"
        opacity:0.8
    }

    function findFile( fileNameValue )
    {
        for (var i = 0; i< lstFileTransfering.count;i++)
        {
            if ( lstFileTransfering.get(i).fileName == fileNameValue)
                return i;
        }
        return -1;
    }

    Connections{
        target:pm


        function onTransfertProgress(localfilePath, percProgress, upload){
            var idx = root.findFile( localfilePath );
            var elem ={
                "fileName" : localfilePath,
                "percProgress" : percProgress,
                "upload" : upload
            }

            if (idx === -1)
                lstFileTransfering.append(elem)
            else lstFileTransfering.set(idx, elem)
        }
        function onTransfertCompleted( localfilePath) {
            lstFileTransfering.remove( root.findFile( localfilePath ), 1);
        }
    }

    ListModel{
        id:lstFileTransfering
        /* TEST DATA
        ListElement{
            fileName:"prout.swag"
            percProgress:40
            upload : true
        }
        ListElement{
            fileName:"zob.swag"
            percProgress:40
            upload : false
        }
        ListElement{
            fileName:"zob.swag"
            percProgress:40
            upload : false
        }
        */
    }

    ListView{
        id:lstView
        anchors.fill:parent
        anchors.margins: 5
        model:lstFileTransfering
        delegate:Column{
            height:30
            width:lstView.width
            Label{
                width:parent.width
                verticalAlignment: Text.AlignTop
                text: qsTr(model.upload ? "Uploading : %1" : "Downloading : %1").arg(model.fileName)
            }
            ProgressBar{
                width:parent.width
                from:0; to:100
                indeterminate: value < 0
                value:Number(model.percProgress)
                Label{
                    text:qsTr("transfered : %1 kb").arg(- parent.value / 10)
                    visible : parent.indeterminate
                    anchors.fill:parent
                }
            }

        }
    }
}
