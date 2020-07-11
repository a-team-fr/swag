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
import Swag 1.0

QtObject{
    id:root
    property string slideDump : ""
    property var target : null

    function qmlCode()
    {
        slideDump ="import QtQuick 2.6\nimport QtQuick.Controls 2.12\nimport Swag 1.0\n";
        dumpObject(target, 0)
        return slideDump
    }

    function addTabulation(rank)
    {
    for (var i=0; i <rank ;i++)
        slideDump +="\t";
    }

    function dumpObject(obj, rank)
    {
        let eltType = obj.elementType
        if (!eltType) return;
        if (obj.notToBeSaved) return;

        addTabulation(rank);

        slideDump += eltType + "{\n";

        //handle id property
        if (obj.idAsAString && obj.idAsAString.length)
        {
            addTabulation(rank);
            slideDump += "id:"+ obj["idAsAString"] + ";\n";
        }

        dumpElement(obj, rank+1)

        //Repeat with children
        if (obj.children){
            for (var i= 0; i< obj.children.length;i++){
                var child = obj.children[i];
                if (!child) continue;
                dumpObject(child,rank+1);
            }
        }
        addTabulation(rank);
        slideDump += "}\n";

    }
    function dumpElement(obj, rank)
    {
        for (var i = 0; i< obj.dumpedProperties.length; i++)
        {
            var prop = obj.dumpedProperties[i];
            if (prop["dumpFunction"])
                slideDump += prop["dumpFunction"](obj,rank, prop);
            else if (obj[prop["name"]]!== prop["default"])
                dumpProperty(obj,prop["name"],rank);
        }

    }
    function dumpArticle(obj, rank)
    {
        dumpProperty(obj,"text",rank);
    }

    function dumpProperty(obj, prop, rank, sep)
    {
        if (sep === undefined) sep = ";"
        let value = obj[prop];
        if (value === undefined) return;

        addTabulation(rank);

        if (typeof(value)==="string")
        {
            value = value.replace(/'/g, '\'');
            value = value.replace(/"/g, "'");
            //value.replace(/"/g, '\"');
            //value = value.split('"').join('\"');
            slideDump += prop + ":\""+ value + "\""+sep + "\n";
        }
        else if (typeof(value)==="object")
        {
            if (Array.isArray(value)){
                slideDump += prop + ": [ \n";
                for (var i = 0; i< value.length; i++)
                {
                    addTabulation(rank);
                    slideDump += "{\n";
                    var elm = value[i];
                    for (var p in elm)
                        dumpProperty(elm, p, rank+1,",")
                    addTabulation(rank);
                    slideDump += "}";
                    if (i!== value.length-1)
                        slideDump += ",\n";
                }

                slideDump += "]\n";
            }
            else if (value.elementType!== undefined){
                slideDump += prop + ":";
                dumpObject(value, rank)
            }

            else slideDump += prop + ":\""+ value + "\""+sep + "\n";
        }
        else slideDump += prop + ":"+ value +sep + "\n";
    }

}
