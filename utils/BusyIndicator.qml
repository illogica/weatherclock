import QtQuick 2.0

Image {
    id: root
    property bool on: false
    source: "../resources/busy.png"

    visible: root.on

    NumberAnimation on rotation{
        running: root.on; from: 0; to: 360; loops: Animation.Infinite; duration: 1200
    }
}

