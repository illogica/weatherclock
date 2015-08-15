import QtQuick 2.0
import "../js/style.js" as Style

Rectangle {
    id: root

    property string text: "Button"

    color: "transparent"

    width: label.width + 15
    height: label.height + 10

    border.width: Style.borderWidth
    border.color: pressedColor(Style.penColor)
    radius: Style.borderRadius

    signal clicked(variant mouse)
    signal pressedAtXY(string coordinates)

    function pressedColor(color){
        return mouseArea.pressed ? Qt.darker(color, 5.0): color
    }

    function logPresses(mouse){
        pressedAtXY(mouse.x + "," + mouse.y)
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(root.clicked)
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: pressedColor(Style.penColor)
        text: parent.text
        font.pixelSize: Style.textPixelSize
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        Connections{
            onPressed: logPresses(mouse)
        }
    }
}

