import QtQuick 2.0

Item {
    id: root
    property bool checked: true
    width: checkBox.width
    height: checkBox.height

    Image{
        id: checkBox
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

