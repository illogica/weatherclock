import QtQuick 2.0
import Qt.labs.settings 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
//import com.illogica.cities 1.0

import "../utils" 1.0
import "../style" 1.0

Rectangle {
    id: root
    clip: true
    property bool showSeconds: true
    property bool showDate: true
    property int forecastUpdateInterval: 5 //minutes
    property bool forceOffline: false
    property bool useFarenheit: false
    property alias locId: citySearchDialog.locationId
    property alias locName: citySearchDialog.locationName

    visible: true
    state: "Invisible"

    width: 320
    height: 480

    states: [
        State{
            name: "Visible"
            PropertyChanges { target: root; x: 0}
        },
        State {
            name: "Invisible"
            PropertyChanges { target: root; x: -(root.width)}
        }
    ]

    Behavior on x {
        NumberAnimation{duration: 600; easing.type: Easing.OutElastic}
    }

    Settings{
        id: settings
        property alias myForecastUpdateInterval: root.forecastUpdateInterval
        property alias myShowSeconds: root.showSeconds
        property alias myShowDate: root.showDate
        property alias myForceOffline: root.forceOffline
        property alias myUseFarenheit: root.useFarenheit
    }

    Image{
        id: background
        source: "../resources/background.png"
        fillMode: "Tile"
        anchors.fill: parent
    }

    Grid{
        id: controlElements
        spacing: 8
        columns: 2
        anchors.left: root.left
        anchors.leftMargin: spacing
        anchors.top: root.top
        anchors.topMargin: spacing
        anchors.right: root.right

        Text{
            id: locationLabel
            text: qsTr("Forecast for: <br>(city name)")
            color: locationTextInput.focus? Qt.lighter(Style.penColor): Style.penColor
            font.pixelSize: Style.textPixelSize
        }

        Text{
            id: locationTextInput
            //width: controlElements.width/2 - (searchCityButton.width*2)
            //text: Cities.locationName
            text: locName
            font.pixelSize: Style.textPixelSize
            color: Style.penColor
        }

        Text{
            id: spacerText
            //width: controlElements.width/2 - (searchCityButton.width*2)
            text: "     "
            font.pixelSize: Style.textPixelSize
            color: Style.penColor
        }

        WCButton{
            id: searchCityButton
            text: qsTr("Change city");
            objectName: "citySearchButton";
            //anchors.left: locationTextInput.right
            //enabled: Cities.citiesLoaded
            visible: true
            onClicked:{
                //Cities.populateCitiesMap();
                citySearchDialog.state = "Visible";
            }
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

        WCCheckBox{
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

        WCCheckBox{
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

        WCCheckBox{
            id: offlineCheckBox
            checked: forceOffline
            KeyNavigation.up: dateCheckBox
            KeyNavigation.down: farenheitCheckBox
        }

        Text{
            id: farenheitLabel
            text: qsTr("Use Farenheit F°")
            color: offlineCheckBox.focus ?
                       Qt.lighter(Style.penColor) : Style.penColor
            font.pixelSize: Style.textPixelSize
        }

        WCCheckBox{
            id: farenheitCheckBox
            checked: useFarenheit
            KeyNavigation.up: offlineCheckBox
            KeyNavigation.down: locationTextInput
        }
    }

    WCDialog{
        id: errorDialog
        width: root.width
        anchors.centerIn: parent
        z: root.z+1
        visible: false
    }

    WCButton{
        id: exitButton
        text: qsTr("OK")
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        onClicked: {
            if(updateTextInput.text == "" || updateTextInput.text === 0)
                errorDialog.show(qsTr("Update interval cannot be empty"))
            else if(locationTextInput.text=="")
                errorDialog.show(qsTr("The location cannot be empty"))
            else {
                forecastUpdateInterval = updateTextInput.text
                root.state = "Invisible"
            }
            root.showSeconds = secondsCheckBox.checked
            root.showDate = dateCheckBox.checked
            root.forceOffline = offlineCheckBox.checked
            root.useFarenheit = farenheitCheckBox.checked
        }
    }

    CityModelItem{
        id: citySearchDialog
        z: root.z + 1
        state: "Invisible"
        anchors.left: root.left
        anchors.right: root.right
    }
}

