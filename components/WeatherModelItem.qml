import QtQuick 2.0
import QtQuick.XmlListModel 2.0
//import com.illogica.cities 1.0
import "../js/globals.js" as Globals

Item {
    id: root

    property alias forecastModel: forecast
    property alias currentModel: current
    property string locationName
    property string locationId
    property bool forceOffline: false
    property int interval: 5
    property bool modelDataError: false
    property string statusMessage: ""

    XmlListModel{
        id: forecast
        source: Globals.weatherForecastBaseUrlByID + locationId + Globals.postFixUrl
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
                    root.statusMessage = "Invalid forecast location: " + root.locationId
                    root.modelDataError = true
                } else {
                    root.state = "Live Weather"
                    root.statusMessage = "Live current weather is available"
                    root.modelDataError = false
                }
            } else if(status == XmlListModel.Loading){
                root.state = "Loading"
                root.statusMessage = "Forecast data is loading..."
            } else if(status == XmlListModel.Null){
                root.state = "Loading"
                root.statusMessage = "Forecast data is empty..."
            } else {
                root.modelDataError = false
            }
        }
    }

    XmlListModel{
        id: current
        source: Globals.weatherCurrentBaseUrlByID + locationId + Globals.postFixUrl
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
                    root.statusMessage = "Invalid current location: " + root.locationId
                    root.modelDataError = true
                } else {
                    root.state = "Live Weather"
                    root.statusMessage = "Live current weather is available"
                    root.modelDataError = false
                }
            } else if(status == XmlListModel.Loading){
                root.state = "Loading"
                root.statusMessage = "Forecast data is loading..."
            } else if(status == XmlListModel.Null){
                root.state = "Loading"
                root.statusMessage = "Forecast data is empty..."
            } else {
                root.modelDataError = false
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

