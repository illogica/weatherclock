import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "../js/globals.js" as Globals

Item {
    id: root

    property alias forecastModel: forecast
    property alias currentModel: current
    property string location: ""
    property bool forceOffline: false
    property string weatherCurrentBaseUrl: "http://api.openweathermap.org/data/2.5/weather?q="
    property string weatherForecastBaseUrl: "http://api.openweathermap.org/data/2.5/forecast?q="
    property string postFixUrl: "&mode=xml"
    property string imageBaseUrl: "http://openweathermap.org/img/w/"
    property string sourceForecast: weatherForecastBaseUrl + location + postFixUrl
    property string sourceCurrent: weatherCurrentBaseUrl + location + postFixUrl
    property int interval: 5
    property bool modelDataError: false
    property string statusMessage: ""

    XmlListModel{
        id: forecast
        source: Globals.getSourceForecast(root.location)
        query: "/weatherdata/forecast/time"

        XmlRole { name: "dateTime"; query: "@from/string()" }
        XmlRole { name: "temperature"; query: "temperature/@value/string()" }
        XmlRole { name: "temperatureLow"; query: "temperature/@min/string()" }
        XmlRole { name: "temperatureHigh"; query: "temperature/@max/string()" }
        XmlRole { name: "icon"; query: "symbol/@var/string()" }
        XmlRole { name: "condition"; query: "symbol/@name/string()" }

        onStatusChanged: {
            root.modelDataError = false
            if(status == XmlListModel.Error){
                root.state = "Offline"
                root.statusMessage = "Error: " + errorString()
                root.modelDataError = true
            } else if(status== XmlListModel.Ready) {
                if(get(0) === undefined){
                    root.state = "Offline"
                    root.statusMessage = "Invalid location: " + root.location
                    root.modelDataError = true
                } else {
                    root.state = "Live Weather"
                    root.statusMessage = "Live current weather is available"
                }
            } else if(status == XmlListModel.Loading){
                root.state = "Loading"
                root.statusMessage = "Forecast data is loading..."
            } else if(status == XmlListModel.Null){
                root.state = "Loading"
                root.statusMessage = "Forecast data is empty..."
            } else {
                root.modelDataError = false
                console.log("Weather clock: unknown XmlListModel status: " + status)
            }
        }
    }

    XmlListModel{
        id: current
        source: Globals.getSourceCurrent(root.location)
        query: "/current"

        XmlRole { name: "condition"; query: "weather/@value/string()" }
        XmlRole { name: "temp"; query: "temperature/@value/string()" }
        XmlRole { name: "humidity"; query: "humidity/@value/string()" }
        XmlRole { name: "icon"; query: "weather/@icon/string()" }
        XmlRole { name: "wind_condition"; query: "wind/speed/@name/string()" }

        onStatusChanged: {
            root.modelDataError = false
            if(status == XmlListModel.Error){
                root.state = "Offline"
                root.statusMessage = "Error: " + errorString()
                root.modelDataError = true
            } else if(status== XmlListModel.Ready) {
                if(get(0) === undefined){
                    root.state = "Offline"
                    root.statusMessage = "Invalid location: " + root.location
                    root.modelDataError = true
                } else {
                    root.state = "Live Weather"
                    root.statusMessage = "Live current weather is available"
                }
            } else if(status == XmlListModel.Loading){
                root.state = "Loading"
                root.statusMessage = "Forecast data is loading..."
            } else if(status == XmlListModel.Null){
                root.state = "Loading"
                root.statusMessage = "Forecast data is empty..."
            } else {
                root.modelDataError = false
                console.log("Weather clock: unknown XmlListModel status: " + status)
            }
        }
    }

    Timer{
        interval: root.interval*60000
        running: Qt.application.active && !root.forceOffline
        repeat: true
        onTriggered: {
            current.reload()
            forecast.reload()
        }
    }
}

