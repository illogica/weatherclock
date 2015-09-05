import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import "../utils" 1.0
import "../style" 1.0
import "../js/licenses.js" as Licenses

Rectangle {
    id: root
    width: 320
    height: 480

    color: Style.backgroundColor
    border.color: Style.penColor
    radius: Style.borderRadius

    states: [
        State {
            name: "Visible"
            PropertyChanges { target: root; y: 0}
        },

        State {
            name: "Invisible"
            PropertyChanges { target: root; y: root.height}
        }
    ]

    Behavior on y {
        NumberAnimation{duration: 300; easing.type: Easing.OutBounce}
    }

    ScrollView{
        id: scrollView
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: buttonOk.top
        anchors.margins: 8

        Column{
            id: column
            spacing: 2
            anchors.horizontalCenter: scrollView.horizontalCenter
            width: root.width

            Image{
                id: headerImage
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../resources/logo_illogica_180x120.png"
                //sourceSize: Qt.size(parent.width, parent.height)
                smooth: true
                visible: true
            }

            Text{
                id: licenceAgreementTitle
                textFormat: Text.RichText
                font.pointSize: Style.textPixelSize
                text: Licenses.license_en_title
                wrapMode: Text.WordWrap
                width: column.width
                color: Style.penColor
            }

            Text{
                id: licenceAgreement
                textFormat: Text.RichText
                font.pointSize: Style.textPixelSize * 0.5
                text: Licenses.license_en
                wrapMode: Text.WordWrap
                width: column.width
                color: Style.penColor

            }

            Column {
                id: rowLinks
                spacing: 2

                WCButton{
                    id: mailButton
                    text: "Contact us: info@illogicasoftware.com"
                    onClicked: Qt.openUrlExternally("mailto: info@illogicasoftware.com?subject=Weatherclock")
                }

                WCButton{
                    id: weatherclockLinkButton
                    text: "Browse Weatherclock sources"
                    onClicked: Qt.openUrlExternally("https://github.com/illogica/weatherclock")
                }

                WCButton{
                    id: openweathermapLinkButton
                    text: "Visit Openweathermap.org"
                    onClicked: Qt.openUrlExternally("http://openweathermap.org/")
                }

                WCButton{
                    id: kdeLinkButton
                    text: "Kde.org"
                    onClicked: Qt.openUrlExternally("https://www.kde.org/")
                }
            }
        }
    }

    WCButton{
        id: buttonOk
        text: qsTr("Ok")
        anchors.bottom: root.bottom
        anchors.horizontalCenter: root.horizontalCenter
        onClicked: root.state = "Invisible"
    }
}

