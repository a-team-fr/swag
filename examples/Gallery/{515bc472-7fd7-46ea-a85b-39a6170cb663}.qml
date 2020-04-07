import QtQuick 2.6
import QtQuick.Controls 2.12
import fr.ateam.swag 1.0
import Swag 1.0
Slide{
	ChartElement{
		xRel:0.11327311197916666;
		yRel:0.051633718922651936;
		widthRel:0.5625895182291667;
		heightRel:0.8950923687845304;
		title:"the chart title";
		dataCharts:		DataElement{
			lstModel : ListModel{
				ListElement{
					values:"[1,2,4,16]";
					value:"10";
					label:"blue";
					y:"1";
					x:"0";
				}
				ListElement{
					values:"[1,2,4,16]";
					value:"20";
					label:"yellow";
					y:"2";
					x:"1";
				}
				ListElement{
					values:"[1,2,4,16]";
					value:"40";
					label:"red";
					y:"4";
					x:"2";
				}
			}
			fields: [ 
			{
				name:"x",
				type:1,
			},
			{
				name:"y",
				type:1,
			},
			{
				name:"label",
				type:1,
			},
			{
				name:"value",
				type:1,
			},
			{
				name:"values",
				type:1,
			}]
		}
	}
}
