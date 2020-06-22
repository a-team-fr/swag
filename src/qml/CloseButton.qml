import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.14
import QtGraphicalEffects 1.12
import Swag 1.0
import fr.ateam.swag 1.0
import MaterialIcons 1.0

Item{
    width : 56; height : 56; z : 100
    x:parent.width - width

    FAButton{
        id:button
        anchors.fill:parent
        onClicked: pm.displayType = pm.loaded ?  PM.Slide :PM.Welcome
        icon : MaterialIcons.close
        color: Material.accent
        rounded : true
    }
    DropShadow{
        anchors.fill: parent
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: button
    }


}
