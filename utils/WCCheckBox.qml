import QtQuick 2.0
import "../style" 1.0

Item {
    id: root
    property bool checked: true
    width: checkBox.width
    height: checkBox.height

    Image{
        id: checkBox
        height: 22 * Style.screenProportion
        width: 22 * Style.screenProportion
        fillMode: Image.PreserveAspectFit
        source: root.checked?
                    "../resources/checkbox.png":
                    "../resources/draw-rectangle.png"
        Keys.onPressed: {
            if(event.key == Qt.Key_Return ||
                    event.key == Qt.Key_Space ||
                    event.key == Qt.Key_Enter)
                root.checked == !root.checked

        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                root.checked = !root.checked
            }
        }
    }
}

