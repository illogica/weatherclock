import QtQuick 2.0
import QtQuick.Window 2.2

import "utils" 1.0
import "components" 1.0
import "style" 1.0
import "js/logic.js" as Logic
import "js/globals.js" as Globals

Rectangle {
    id: root
    property string defaultLocation: configure.locationText
    property int defaultInterval: configure.forecastUpdateInterval
    property bool showSeconds: configure.showSeconds
    property bool showDate: configure.showDate
    property bool forceOffline: configure.forceOffline
    state: forceOffline ? "Offline" : weatherModelItem.state

    width: Window.width
    height: Window.height

    onStateChanged: {
        if (state == "Offline")
            statusText.showStatus("offline");
        else if(state == "Loading")
            statusText.showStatus("loading...");
        else if(state == "Live Weather")
            statusText.showStatus("live weather");
    }

    Image {
        id: background
        source: "resources/light_background.png"
        fillMode: "Tile"
        anchors.fill: parent
        onStatusChanged: if (background.status == Image.Error)
                             console.log("Background image \"" +
                                         source +
                                         "\" cannot be loaded")
    }

    Dialog{
        id: errorDialog
        width: root.width
        anchors.centerIn: parent
        z: root.z+1
        visible: false
    }

    WeatherModelItem{
        id: weatherModelItem
        location: root.defaultLocation
        interval: root.defaultInterval
        forceOffline: root.forceOffline
        onModelDataErrorChanged: {
            if(weatherModelItem.modelDataError){
                errorDialog.show(weatherModelItem.statusMessage)
            }
        }
    }

    Component{
        id: weatherForecastDelegate

            Weather{
                id: weatherForecastItem

                labelText: Globals.whichDay(Logic.dateFromXmlString(model.dateTime)) + "\n" + Logic.timeFromXmlString(model.dateTime)
                conditionText: model.condition
                tempText: Globals.fixTemperature(model.temperature) + "C°"
                conditionImageUrl:  Globals.getWeatherImage(model.icon)

                Behavior on x {
                    NumberAnimation{duration:500; easing.type: Easing.OutElastic}
                }
                Behavior on y {
                    NumberAnimation{duration:500; easing.type: Easing.OutElastic}
                }

        }
    }

    Component{
        id: weatherCurrentDelegate
        Weather{
            id: currentWeatherItem
            labelText: root.defaultLocation
            conditionText: model.condition
            conditionImageUrl: Globals.getWeatherImage(model.icon)
            tempText: Globals.fixTemperature(model.temp) + "C°"
        }
    }

    NightClock{
        id: clockScreen
        height: 110 * (Screen.pixelDensity / Style.dpmRatio)
        anchors.centerIn: root
        showDate: root.showDate
        showSeconds: root.showSeconds
        textColor: Style.offlineClockTextColor
    }

    Item{
        id: weatherScreen
        width: root.width
        height: root.height
        anchors.top: parent.top
        anchors.bottom: bottomButtonsRow.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Style.baseMargin

        Flow{
            id:weatherScreenHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Style.baseMargin
            spacing: 30

            NightClock{
                id: clock
                height: 80 * Style.screenProportion
                width: 180 * Style.screenProportion
                //anchors.centerIn: root
                showDate: root.showDate
                showSeconds: root.showSeconds
                textColor: Style.onlineClockTextColor
            }

            ListView{
                id: currentWeatherView
                width: 100
                height: 100
                model: weatherModelItem.currentModel
                delegate: weatherCurrentDelegate
                interactive: false
            }
            move: Transition {
                NumberAnimation{
                    properties: "x,y"
                    duration: 500
                    easing.type: Easing.OutBounce
                }
            }
        }

        GridView{
            id: forecastGrid
            anchors.top: weatherScreenHeader.bottom
            anchors.left: weatherScreen.left
            anchors.right: weatherScreen.right
            anchors.margins: Style.baseMargin
            anchors.bottom: statusText.top
            width: weatherScreen.width
            height: weatherScreen.height - weatherScreenHeader.height - bottomButtonsRow.height - statusText.height
            cellHeight: Style.forecastCellHeight * Style.screenProportion
            cellWidth: Style.forecastCellWidth * Style.screenProportion
            clip: true

            model: weatherModelItem.forecastModel
            delegate: weatherForecastDelegate

            move: Transition {
                NumberAnimation{
                    properties: "x,y"
                    duration: 500
                    easing.type: Easing.OutBounce
                }
            }
        }
    }

    Text{
        id: statusText
        anchors.horizontalCenter: root.horizontalCenter
        anchors.bottom: bottomButtonsRow.top
        anchors.margins: Style.baseMargin
        color: Qt.lighter(Style.penColor)
        font.pixelSize: Style.textPixelSize * 0.8
        text: qsTr("Status: starting...")

        function showStatus(newStatusText){
            text = qsTr("Status: " + newStatusText);
        }
    }

    BusyIndicator{
        id: busyIndicator
        anchors.horizontalCenter: root.horizontalCenter
        anchors.bottom: statusText.top
        anchors.margins: Style.baseMargin
    }

    Row{
        id: bottomButtonsRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        spacing: (root.width - exitButton.width - configureButton.width - toggleStatesButton.width)/2

        Button{
            id: configureButton
            text: qsTr("Config")
            anchors.margins: Style.baseMargin
            onClicked: configure.visible = true
        }

        Button{
            id: exitButton
            text: qsTr("Exit")
            width: configureButton.width
            anchors.margins: Style.baseMargin
            onClicked: Qt.quit()
        }

        Button{
            id: toggleStatesButton
            anchors.margins: Style.baseMargin
            text: root.state == "Offline" ? qsTr("Get weather"): qsTr("Go offline");
            onClicked: {
                if(root.state=="Offline")
                    configure.forceOffline = false;
                else
                    configure.forceOffline = true;
            }
        }
    }

    Configure{
        id: configure
        anchors.fill: root
        z: root.z+1
        visible: false
        showSeconds: true
        showDate: true
        forecastUpdateInterval: 5
        //locationText: qsTr("London")
        forceOffline: false
    }

    states: [
        State{
            name: "Offline"
            PropertyChanges {target: clockScreen; visible: true}
            PropertyChanges {target: weatherScreen; visible: false}
        },
        State{
            name: "Live Weather"
            PropertyChanges {target: clockScreen; visible: false}
            PropertyChanges {target: weatherScreen; visible: true}
        },
        State{
            name: "Loading"
            PropertyChanges {target: clockScreen; visible: true}
            PropertyChanges {target: weatherScreen; visible: false}
            PropertyChanges {target: busyIndicator; on: true}
        }
    ]

    transitions: [
        Transition {
            from: "Live Weather"
            to: "Offline"
            PropertyAnimation{
                target: clockScreen
                property: opacity
                from: 0
                to: 1
                easing.type: Easing.Linear
                duration: 5000
            }
        },
        Transition {
            from: "Offline"
            to: "Live Weather"
            PropertyAnimation{
                target: clockScreen
                property: opacity
                from: 0
                to: 1
                easing.type: Easing.Linear
                duration: 5000
            }
        }
    ]
}

