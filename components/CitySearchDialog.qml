import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import com.illogica.cities 1.0
import "../style" 1.0
import "../utils" 1.0

Rectangle {
    id: root
    property string title: "Enter the city name"
    width: 300
    height: 240

    color: Style.backgroundColor
    border.color: Style.penColor
    border.width: Style.borderWidth
    radius: Style.borderRadius
    state: "Invisible"

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
        inputMethodHints: Qt.ImhNoPredictiveText
        //placeholderText: "Insert city name here"
        font.pixelSize: Style.textPixelSize
        //color: Style.penColor
        anchors.margins: Style.baseMargin
        anchors.top:dialogTitle.bottom
        anchors.left: root.left
        anchors.right: useButton.left

        style: TextFieldStyle{
            textColor: "grey"//Style.penColor
        }

        onTextChanged: {
            if(text.trim() != ""){
                Cities.parse(text.trim());
            }
        }

        onFocusChanged: {
            if(focus) Qt.inputMethod.show()
        }
    }

    WCButton{
        id: useButton
        anchors.right: root.right
        anchors.top: dialogTitle.bottom
        text: qsTr("Use")
        onClicked: {
            if(cityNameTextInput.text.trim()!=""){
                Cities.locationName = cityNameTextInput.text.trim();
                Cities.locationId = "0";
                root.state = "Invisible"
            }
        }
    }

    ListView {
        id: listViewMatchedCities
        anchors.left: cityNameTextInput.left
        anchors.top: cityNameTextInput.bottom
        anchors.right: cityNameTextInput.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Style.baseMargin
        visible: false
        model: Cities.matchesModel
        clip: true

        delegate: Text{
            color: Style.penColor
            font.pixelSize: Style.textPixelSize
            text: modelData.name
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    if(modelData.name !== qsTr("Not found")){
                        Cities.locationName = modelData.name;
                        Cities.locationId = modelData.idString;
                        root.state = "Invisible"
                        Qt.inputMethod.hide()
                    }
                }
            }
        }

        onModelChanged: {
            listViewMatchedCities.visible = true;
        }
    }
}
