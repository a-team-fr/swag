import QtQuick 2.6
import QtQuick.Controls 2.12
import Swag 1.0
Slide{
	ImageElement{
	id:myImg;
		idAsAString:"myImg";
		xRel:0.06064453125;
		yRel:0.17010528212520593;
		widthRel:0.2876802884615385;
		heightRel:0.5200975597199341;
		source:"qrc:/res/desert-279862_1920.jpg";
		fillMode:1;
	}
	WebElement{
	id:theWeb;
		navigationFocus:true;
		idAsAString:"theWeb";
		xRel:0.3862542390022782;
		yRel:0.09371566587714818;
		widthRel:0.562667890343601;
		heightRel:0.7351266535575611;
		url:"http://alliance-libre.org/";
	}
	ButtonElement{
		xRel:0.030041920731707316;
		yRel:0.04092920353982301;
		widthRel:0.2833955792682927;
		heightRel:0.11790652654867256;
		onClicked:"if (theWeb.url != Qt.url('https://www.alsim.com') )
theWeb.url = 'https://www.alsim.com'
else theWeb.url = 'http://www.alliance-libre.org'";
		text:"Hey, I am a button!";
		color:"#ffffff";
		iconColor:"#ffffff";
	}
	InputElement{
		xRel:0.046153863889222387;
		yRel:0.7561481906030575;
		widthRel:0.26532075477348654;
		heightRel:0.13891320836053922;
		text:"http://alliance-libre.org";
		onEditingFinished:"theWeb.url = text";
	}
}
