import QtQuick 2.6
import QtQuick.Controls 2.12
import fr.ateam.swag 1.0
import Swag 1.0
Slide{
	MCQElement{
		xRel:0.08021647135416667;
		yRel:0.03705542127071823;
		widthRel:0.6140380859375;
		heightRel:0.9173806543508287;
		question:"Quelle est la bonne réponse à la question ?";
		answerHeight:140;
		dataMCQ:		DataElement{
			lstModel : ListModel{
				ListElement{
					isCorrect:false;
					backTextFill:true;
					backImage:"qrc:/res/road-1303617_1920.jpg";
					backText:"ben non...c'est pas un jeu à la con !";
					backLayout:1;
					frontTextFill:true;
					frontImage:"qrc:/res/road-1303617_1920.jpg";
					frontText:"la réponse D...";
					frontLayout:2;
				}
				ListElement{
					isCorrect:true;
					backTextFill:true;
					backImage:"";
					backText:"yeah that's the one !";
					backLayout:0;
					frontTextFill:true;
					frontImage:"";
					frontText:"42";
					frontLayout:0;
				}
				ListElement{
					isCorrect:false;
					backTextFill:true;
					backImage:"";
					backText:"";
					backLayout:0;
					frontTextFill:true;
					frontImage:"";
					frontText:"j'en sais rien";
					frontLayout:0;
				}
				ListElement{
					isCorrect:true;
					backTextFill:true;
					backImage:"";
					backText:"yeah that's another one !";
					backLayout:0;
					frontTextFill:true;
					frontImage:"";
					frontText:"42";
					frontLayout:0;
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
