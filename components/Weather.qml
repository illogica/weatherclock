import QtQuick 2.0
import QtQuick.Window 2.2
import "../style" 1.0

Item {
    id: root
    property string labelText:qsTr("Title Looooong")
    property string conditionText: qsTr("Sunny")
    property string conditionImageUrl: ""
    property string tempText: qsTr("-88C°")
    width: Style.forecastCellWidth
    height: Style.forecastCellHeight

    Image{
        id: icon
        anchors.fill: parent
        anchors.margins: width/5
        smooth: true
        source: conditionImageUrl
        onStatusChanged: {
            if(status == Image.Error) console.log("Error loading conditionImage")
            console.log("Screen proportion: " + Style.screenProportion)
        }
    }

    Text{
        id:label
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        text: root.labelText
        font.bold: true
        font.pixelSize: root.height * Style.textSizeDayProportion
        horizontalAlignment: Text.AlignLeft
        wrapMode: "WordWrap"
        color: Style.forecastTextColor
        style: Text.Raised
        styleColor: "black"
    }

    Text {
        id: condition
        anchors.top: label.bottom
        anchors.left: label.left
        anchors.margins: 2
        text: root.conditionText
        font.bold: true
        font.pixelSize: root.height*Style.textSizeForecastProportion
        color: Style.forecastTextColor
        style: Text.Raised
        styleColor: "black"
    }

    Text {
        id: temp
        anchors.left: condition.left
        anchors.top: condition.bottom
        text: root.tempText
        font.pixelSize: root.height*Style.textSizeTempProportion
        color: Style.forecastTextColor
        style: Text.Raised
        styleColor: "black"
    }
}

