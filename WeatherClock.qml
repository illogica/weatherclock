import QtQuick 2.0
import QtQuick.Window 2.2
//import com.illogica.cities 1.0

import "utils" 1.0
import "components" 1.0
import "style" 1.0
import "js/logic.js" as Logic
import "js/globals.js" as Globals

Rectangle {
    id: root

    //Configuration is loaded from a C++ singleton
    property string defaultLocation: configure.locName
    property string defaultLocationId: configure.locId

    property int defaultInterval: configure.forecastUpdateInterval
    property bool showSeconds: configure.showSeconds
    property bool showDate: configure.showDate
    property bool forceOffline: configure.forceOffline
    property bool useFarenheit: configure.useFarenheit
    state: forceOffline ? "Offline" : weatherModelItem.state

    width: Window.width
    height: Window.height

    //We have 3 possible states:
    onStateChanged: {
        if (state == "Offline")
            statusText.showStatus("offline");
        else if(state == "Loading")
            statusText.showStatus("loading...");
        else if(state == "Live Weather")
            statusText.showStatus("live weather");
    }

    //The background image
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

    //Load a custom made error dialog
    WCDialog{
        id: errorDialog
        width: root.width
        anchors.centerIn: parent
        z: root.z+1
        visible: false
    }

    //A standard weather module
    WeatherModelItem{
        id: weatherModelItem
        locationId: root.defaultLocationId
        locationName: root.defaultLocation
        interval: root.defaultInterval
        forceOffline: root.forceOffline
        onModelDataErrorChanged: {
            if(weatherModelItem.modelDataError){
                errorDialog.show(weatherModelItem.statusMessage)
            }
        }
    }

    //The delegate for the weather forecast
    Component{
        id: weatherForecastDelegate

        Weather{
            id: weatherForecastItem

            labelText: Globals.whichDay(Logic.dateFromXmlString(model.dateTime)) + "\n" + Logic.timeFromXmlString(model.dateTime)
            conditionText: model.condition
            tempText: if(useFarenheit){
                          '<font color="lightskyblue">' + (Logic.k2f(model.temperatureLow)) + "F°</font>" +
                                  '/<font color="tomato">' + (Logic.k2f(model.temperatureHigh)) + "F°</font>"}
                      else {
                          '<font color="lightskyblue">' + (Logic.k2c(model.temperatureLow)) + "C°</font>" +
                                  '/<font color="tomato">' + (Logic.k2c(model.temperatureLow)) + "C°</font>"}

            conditionImageUrl:  Globals.getWeatherImage(model.icon)

            Behavior on x {
                NumberAnimation{duration:500; easing.type: Easing.OutElastic}
            }
            Behavior on y {
                NumberAnimation{duration:500; easing.type: Easing.OutElastic}
            }

        }
    }

    //The delegate for the small current weather condition, shown closed to the clock
    Component{
        id: weatherCurrentDelegate
        Weather{
            id: currentWeatherItem
            labelText: defaultLocation
            conditionText: model.condition
            conditionImageUrl: Globals.getWeatherImage(model.icon)
            tempText: if(useFarenheit)(Logic.k2f(model.temp) + "F°")
                      else (Logic.k2c(model.temp) + "C°")
        }
    }

    NightClock{
        id: clockScreen
        height: 105 * Style.screenProportion
        anchors.centerIn: root
        showDate: root.showDate
        showSeconds: root.showSeconds
        textColor: Style.offlineClockTextColor
    }

    Item{
        id: weatherScreen
        anchors.top: parent.top
        anchors.bottom: statusText.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Style.baseMargin

        Grid{
            id:weatherScreenHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Style.baseMargin
            spacing: 20

            NightClock{
                id: clock
                height: 70 * Style.screenProportion
                width: 150 * Style.screenProportion
                showDate: root.showDate
                showSeconds: root.showSeconds
                textColor: Style.onlineClockTextColor
            }

            ListView{
                id: currentWeatherView
                width: height
                height: clock.height//100
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

        Text{
            id: forecastHeaderText
            text: qsTr("Next five days:")
            anchors.left: root.left
            anchors.top: weatherScreenHeader.bottom
            color: Style.forecastTextColor
            font.pixelSize: Style.textPixelSize
            anchors.margins: Style.baseMargin
            style: Text.Raised
            styleColor: "black"
        }

        GridView{
            id: forecastGrid
            anchors.top: forecastHeaderText.bottom
            anchors.left: weatherScreen.left
            anchors.right: weatherScreen.right
            anchors.bottom: weatherScreen.bottom
            anchors.margins: Style.baseMargin
            width: weatherScreen.width
            cellHeight: Style.forecastCellHeight
            cellWidth:  Style.calculateWeatherCellWidth(parent.width)
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

        WCButton{
            id: configureButton
            text: qsTr("Config")
            anchors.margins: Style.baseMargin
            onClicked: {
                configure.visible = true
                configure.state = "Visible"
            }
        }

        WCButton{
            id: exitButton
            text: qsTr("Exit")
            width: configureButton.width
            anchors.margins: Style.baseMargin
            onClicked: Qt.quit()
        }

        WCButton{
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

    WCButton{
        id: infoButton
        anchors.right: root.right
        anchors.top: root.top
        text: "Info"
        onClicked: {
            info.state = "Visible"
            info.visible = true
        }
    }

    Configure{
        id: configure
        objectName: "configure"
        anchors.top: root.top
        anchors.bottom: root.bottom
        width: root.width
        z: root.z+1
        visible: false
        showSeconds: true
        showDate: true
        forecastUpdateInterval: 5
        forceOffline: false
        useFarenheit: false
        state: "Invisible"
    }

    Info{
        id: info
        height: root.height
        anchors.left: root.left
        anchors.right: root.right
        z: root.z + 1
        visible: false
        state: "Invisible"
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
                property: "opacity"
                from: 0
                to: 1.0
                easing.type: Easing.Linear
                duration: 5000
            }
            PropertyAnimation{
                target: weatherScreen
                property: "opacity"
                from: 1.0
                to: 0.0
                easing.type: Easing.Linear
                duration: 5000
            }
        },
        Transition {
            from: "Offline"
            to: "Live Weather"
            PropertyAnimation{
                target: clockScreen
                property: "opacity"
                from: 1.0
                to: 0
                easing.type: Easing.Linear
                duration: 4000
            }
            PropertyAnimation{
                target: weatherScreen
                property: "opacity"
                from: 0
                to: 1.0
                easing.type: Easing.Linear
                duration: 4000
            }
        },
        Transition {
            from: "Live Weather"
            to: "Loading"
            PropertyAnimation{
                target: weatherScreen
                property: "opacity"
                from: 0
                to: 1.0
                easing.type: Easing.Linear
                duration: 2000
            }
        },
        Transition {
            from: "Loading"
            to: "Live Weather"
            PropertyAnimation{
                target: weatherScreen
                property: "opacity"
                from: 0
                to: 1.0
                easing.type: Easing.Linear
                duration: 2000
            }
        }
    ]
}

