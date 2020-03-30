import QtQuick 2.6
import QtQuick.Controls 2.12
import Swag 1.0
Slide{
	ButtonElement{
		xRel:0.6585175304878049;
		yRel:0.07763412610619469;
		widthRel:0.2072903963414634;
		heightRel:0.17963910398230087;
		text:"Hey, I am a button!";
		color:"#ffffff";
		iconColor:"#ffffff";
	}
	MapElement{
		xRel:0.11042751736111112;
		yRel:0.07246525379834254;
		widthRel:0.47701822916666664;
		heightRel:0.863038458218232;
		centerLatitude:16.03118189376216;
		centerLongitude:1.636867;
		zoomLevel:7.69480806782393;
		tilt:50.075226913970006;
		pluginName:"osm";
		activeMapTypeIndex:1;
	}
	TextElement{
		xRel:0.6665129573170732;
		yRel:0.32247649336283185;
		widthRel:0.19792301829268294;
		heightRel:0.32517975663716814;
		text:"gkgjjgjdijd";
		color:"#4cffffff";
	}
	MCQElement{
		xRel:0.5099039713541667;
		yRel:0.6863292040745856;
		widthRel:0.4659695095486111;
		heightRel:0.5894229109116023;
		question:"Quelle est la bonne réponse ?";
		answerHeight:140;
		dataMCQ:		DataElement{
			lstModel : ListModel{
				ListElement{
					frontLayout:0;
					frontText:"c'est la une";
					frontImage:"";
					backLayout:0;
					backText:"parce que....";
					backImage:"";
					isCorrect:true;
				}
				ListElement{
					frontLayout:0;
					frontText:"réponse B";
					frontImage:"";
					backLayout:0;
					backText:"";
					backImage:"";
					isCorrect:false;
				}
			}
			fields: [ 
			{
				name:"frontLayout",
				type:0,
				values: [ 
				{
					value:0,
					label:"Overlapped",
				},
				{
					value:2,
					label:"TextLeft",
				},
				{
					value:1,
					label:"ImageLeft",
				}]
			},
			{
				name:"frontText",
				type:1,
			},
			{
				name:"frontImage",
				type:1,
			},
			{
				name:"frontTextFill",
				type:2,
			},
			{
				name:"backLayout",
				type:0,
				values: [ 
				{
					value:0,
					label:"Overlapped",
				},
				{
					value:2,
					label:"TextLeft",
				},
				{
					value:1,
					label:"ImageLeft",
				}]
			},
			{
				name:"backText",
				type:1,
			},
			{
				name:"backImage",
				type:1,
			},
			{
				name:"backTextFill",
				type:2,
			},
			{
				name:"isCorrect",
				type:2,
			}]
		}
	}
}
