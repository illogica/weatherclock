import QtQuick 2.0
import "../style" 1.0

Item {
    id: root
    property bool enabled: true
    width: searchButton.width
    height: searchButton.height

    signal searchButtonClicked()

    Image{
        id: searchButton
        height: 22 * Style.screenProportion
        width: 22 * Style.screenProportion
        fillMode: Image.PreserveAspectFit
        source: root.enabled?
                    "../resources/search-off.png":
                    "../resources/search-off.png"
        Keys.onPressed: {
            if(event.key == Qt.Key_Return ||
                    event.key == Qt.Key_Space ||
                    event.key == Qt.Key_Enter)
                root.checked == !root.checked

        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                root.searchButtonClicked()
            }
        }
    }
}
