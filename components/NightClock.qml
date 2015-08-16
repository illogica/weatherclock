import QtQuick 2.0
import QtQuick.Window 2.2
import "../js/logic.js" as Logic
import "../style" 1.0

Rectangle {
    id:root

    property bool showDate: true
    property bool showSeconds: true
    property string currentTime
    property string currentDate
    property string textColor: "green"

    //property int updatedWidth : 240

    width: 120 * (Screen.pixelDensity / Style.dpmRatio)
    height: 250 * (Screen.pixelDensity / Style.dpmRatio)

    color: "transparent"

    function updateTime(){
        root.currentTime = Logic.getFormattedDateTime(Style.timeFormat) + (showSeconds? (" :" + Logic.getFormattedDateTime("ss")) : "");
        root.currentDate = Logic.getFormattedDateTime(Style.dateFormat)
    }

    Image{
        id: background
        source: "../resources/light_background.png"
        fillMode: "Tile"
        anchors.fill: parent
        onStatusChanged: if(background.status == Image.Error){
                             console.log("Impossibile caricare immagine.")
                         }
    }

    FontLoader{
        id: ledFont
        source: "../resources/font/LED_REAL.TTF"
        onStatusChanged: if(ledFont.status == FontLoader.Error){
                             console.log("Impossibile caricare font.")
                         }
    }

    Timer{
        id: updateTimer
        running: Qt.application.active && visible == true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            updateTime()
            interval = 1000*(showSeconds? 1 : (60- Logic.getFormattedDateTime("ss")))
        }
    }

    onShowSecondsChanged: updateTime()

    Column{
        id: clockText
        anchors.centerIn: parent
        spacing: root.height * Style.borderProportion

        Text{
            id: timeText
            text: root.currentTime
            font.pixelSize: root.height*Style.timeTextProportion
            font.family: ledFont.name
            font.bold: true
            color: root.textColor
            style: Text.Raised
            styleColor: "black"
        }

        Text{
            id: dateText
            text: root.currentDate
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: root.height*Style.dateTextProportion
            font.family: ledFont.name
            color: root.textColor
            style: Text.Raised
            styleColor: "black"
            visible: showDate
        }
    }
}

