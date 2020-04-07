import QtQuick 2.6
import QtQuick.Controls 2.12
import Swag 1.0
Slide{
	TextElement{
		navigationFocus:true;
		xRel:0.7297526041666667;
		yRel:0.0656616885359116;
		widthRel:0.19769151475694444;
		heightRel:0.2690186895718232;
		text:"very long text lorem ipsum itum tutitumvery long text lorem ipsum itum tutitumvery long text lorem ipsum itum tutitumvery long text lorem ipsum itum tutitumvery long text lorem ipsum itum tutitumvery long text lorem ipsum itum tutitum...";
		color:"#ffffff";
		wrapMode:4;
	}
	ButtonElement{
		xRel:0.8116156684027778;
		yRel:0.7463041695441989;
		widthRel:0.12462836371527777;
		heightRel:0.09475353936464088;
		onClicked:"{pm.selectSlide(3)}";
		text:"back to beginning";
		color:"#ffffff";
		iconColor:"#ffffff";
	}
	TocElement{
		xRel:0.09469129774305556;
		yRel:0.11421464951657459;
		widthRel:0.35024956597222223;
		heightRel:0.5236425241712708;
	}
	Entity3DElement{
		xRel:0.4710666232638889;
		yRel:0.44156271581491713;
		widthRel:0.26810980902777776;
		heightRel:0.41506603936464087;
		meshPath:"toyplane.obj";
		position: Qt.vector3d(-37.919551849365234, 19.152935028076172, 24.856353759765625);
		upVector: Qt.vector3d(0.32317009568214417, 0.9211751222610474, -0.21679586172103882);
		viewCenter: Qt.vector3d(-37.919551849365234, 19.152935028076172, 24.856353759765625);
	}
}
