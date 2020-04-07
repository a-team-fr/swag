import QtQuick 2.6
import QtQuick.Controls 2.12
import fr.ateam.swag 1.0
import Swag 1.0
Slide{
	DatavizElement{
		xRel:0.07423502604166667;
		yRel:0.01980101864640884;
		widthRel:0.7626085069444445;
		heightRel:0.9088505697513812;
		theme:3;
		type:2;
		dataSource:		DataElement{
			lstModel : ListModel{
				ListElement{
					values:"";
					value:"1";
					label:"";
					z:"1";
					y:"1";
					x:"1";
				}
				ListElement{
					values:"";
					value:"2";
					label:"";
					z:"-2";
					y:"2";
					x:"-2";
				}
				ListElement{
					values:"";
					value:"3";
					label:"";
					z:"3";
					y:"3";
					x:"3";
				}
				ListElement{
					values:"";
					value:"1,5";
					label:"";
					z:"3,2";
					y:"2";
					x:"1,5";
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
				name:"z",
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
