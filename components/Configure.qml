import QtQuick 2.0
import Qt.labs.settings 1.0
import "../utils" 1.0
import "../js/style.js"  as Style

Rectangle {
    id: root
    property bool showSeconds: true
    property bool showDate: true
    property int forecastUpdateInterval: 5 //minutes
    property string locationText: "Roma"
    property bool forceOffline: false

    width: 320
    height: 480

    Settings{
        id: settings
        property alias mylocationText: root.locationText
        property alias myForecastUpdateInterval: root.forecastUpdateInterval
        property alias myShowSeconds: root.showSeconds
        property alias myShowDate: root.showDate
        property alias myForceOffline: root.forceOffline
    }

    Image{
        id: background
        source: "../resources/background.png"
        fillMode: "Tile"
        anchors.fill: parent
    }

    Grid{
        id: controlElements
        spacing: 10
        columns: 2
        anchors.left: root.left
        anchors.leftMargin: spacing
        anchors.verticalCenter: root.verticalCenter
        anchors.right: root.right

        Text{
            id: locationLabel
            text: qsTr("Forecast for: <br>(city name)")
            color: locationTextInput.focus? Qt.lighter(Style.penColor): Style.penColor
            font.pixelSize: Style.textPixelSize
        }

        TextInput{
            id: locationTextInput
            width: controlElements.width - locationTextInput.x - controlElements.spacing
            text: locationText
            font.pixelSize: Style.textPixelSize
            color: Style.penColor
            //focus: true
            KeyNavigation.up: offlineCheckBox
            KeyNavigation.down: updateTextInput
        }

        Text{
            id: updateLabel
            height: 90
            text: qsTr("Udpate interval: <br>(in min)")
            color: updateTextInput.focus? Qt.lighter(Style.penColor): Style.penColor
            font.pixelSize: Style.textPixelSize
        }

        TextInput{
            id: updateTextInput
            width: locationTextInput.width
            text: forecastUpdateInterval
            font.pixelSize: Style.textPixelSize
            color: Style.penColor
            maximumLength: 3
            validator: IntValidator{bottom: 1; top:999}
            //focus: true
            KeyNavigation.up: locationTextInput
            KeyNavigation.down: secondsCheckBox
        }

        Text{
            id: secondsLabel
            text: qsTr("Show seconds:")
            color: secondsCheckBox.focus ?
                Qt.lighter(Style.penColor) : Style.penColor
            font.pixelSize: Style.textPixelSize
        }

        CheckBox{
            id: secondsCheckBox
            checked: showSeconds
            KeyNavigation.up: updateTextInput
            KeyNavigation.down: dateCheckBox
        }

        Text{
            id: dateLabel
            text: qsTr("Show date:")
            color: dateCheckBox.focus ?
                Qt.lighter(Style.penColor) : Style.penColor
            font.pixelSize: Style.textPixelSize
        }

        CheckBox{
            id: dateCheckBox
            checked: showDate
            KeyNavigation.up: secondsCheckBox
            KeyNavigation.down: offlineCheckBox
        }

        Text{
            id: offlineLabel
            text: qsTr("Clock only")
            color: offlineCheckBox.focus ?
                Qt.lighter(Style.penColor) : Style.penColor
            font.pixelSize: Style.textPixelSize
        }

        CheckBox{
            id: offlineCheckBox
            checked: forceOffline
            KeyNavigation.up: dateCheckBox
            KeyNavigation.down: locationTextInput
        }
    }

    Dialog{
        id: errorDialog
        width: root.width
        anchors.centerIn: parent
        z: root.z+1
        visible: false
    }

    Button{
        id: exitButton
        text: qsTr("OK")
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        onClicked: {
            if(updateTextInput.text == "" || updateTextInput.text == 0)
                errorDialog.show(qsTr("Update interval cannot be empty"))
            else if(locationTextInput.text=="")
                errorDialog.show(qsTr("The location cannot be empty"))
            else {
                forecastUpdateInterval = updateTextInput.text
                root.locationText = locationTextInput.text
                root.visible = false
            }
            root.showSeconds = secondsCheckBox.checked
            root.showDate = dateCheckBox.checked
            root.forceOffline = offlineCheckBox.checked
        }
    }
}

