import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Qt.labs.settings 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import "../js/globals.js" as Globals
import "../style" 1.0
import "../utils" 1.0

Rectangle {
    id: root
    height: 300
    width: 240

    property string locationId: "3165201"
    property string locationName: "Munich"
    property string searchLocationName: "Munich"
    property string title: "Enter the city name"
    property string modelState : "Null"

    color: Style.backgroundColor
    border.color: Style.penColor
    border.width: Style.borderWidth
    radius: Style.borderRadius

    states: [
        State {
            name: "Visible"
            PropertyChanges { target: root; y: 0}
        },

        State {
            name: "Invisible"
            PropertyChanges { target: root; y: -(root.height)}
        }
    ]

    Behavior on y {
        NumberAnimation{duration: 300; easing.type: Easing.OutBounce}
    }

    Settings{
        id: settings
        property alias myLocationId: root.locationId
        property alias myLocationName: root.locationName
        property alias mySearchLocationName: root.searchLocationName
    }

    XmlListModel{
        id: cities
        source: Globals.citiesSearchBaseUrl + searchLocationName + Globals.citiesSearchPostfix
        query: "/cities/list/item"

        XmlRole{name: "cityId"; query: "city/@id/string()" }
        XmlRole{name: "cityName"; query: "city/@name/string()" }
        XmlRole{name: "cityCountry"; query: "city/country/string()" }

        onStatusChanged: {
            switch(status){
            case XmlListModel.Error:
                root.modelState = "Error"
                break;
            case XmlListModel.Loading:
                root.modelState = "Loading"
                break;
            case XmlListModel.Ready:
                root.modelState = "Ready"
                break;
            case XmlListModel.Null:
                root.modelState = "Null"
                break;
            }
        }
    }

    Text{
        id: dialogTitle
        anchors.top: parent.top
        anchors.topMargin: Style.baseMargin
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        wrapMode: "WordWrap"
        text: root.title
        font.pixelSize: Style.textPixelSize
        color: Style.penColor
    }

    TextField{
        id: cityNameTextInput
        text: searchLocationName
        inputMethodHints: Qt.ImhNoPredictiveText
        font.pixelSize: Style.textPixelSize
        anchors.margins: Style.baseMargin
        anchors.top:dialogTitle.bottom
        anchors.left: root.left
        //anchors.right: useButton.left

        style: TextFieldStyle{
            textColor: "grey"//Style.penColor
        }

        onTextChanged: {
            if(text.trim() != ""){
                searchLocationName = text.trim();
            }
        }

        onFocusChanged: {
            if(focus) Qt.inputMethod.show()
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.left: cityNameTextInput.right
        anchors.top: cityNameTextInput.top
        on: root.modelState=="Loading"
        visible: root.modelState == "Loading"
    }


    ListView{
        id: listViewMatchedCities
        anchors.left: cityNameTextInput.left
        anchors.top: cityNameTextInput.bottom
        anchors.right: cityNameTextInput.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.baseMargin

        delegate: Text{
            id: cityDelegate
            text: cityName + ", " + cityCountry
            color: Style.penColor
            font.pixelSize: Style.textPixelSize
            MouseArea{
                anchors.fill: parent
                onClicked:{
                        root.locationId = cityId
                        root.locationName = cityName
                        root.state = "Invisible"
                        Qt.inputMethod.hide()
                }
            }
        }
        model: cities
        focus: true

        onModelChanged: {
            listViewMatchedCities.visible = true;
        }
    }
}
