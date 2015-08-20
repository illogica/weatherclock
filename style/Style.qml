pragma Singleton
import QtQuick 2.3
import QtQuick.Window 2.2

QtObject {
    id: singleton
    property string backgroundImage : "background.png"

    //Scale all the size according to Screen.pixelDensity
    property real dpmRatio: 3
    property real screenProportion: Screen.logicalPixelDensity / dpmRatio

    // color used to paint text and button borders
    property string penColor: "lightgrey"

    // size of of the UI texts
    property int textPixelSize : 20 * screenProportion

    // ??
    property int baseMargin : 5

    // background color for UI elements used when the backgroundImage is not visible
    property string backgroundColor:  "black"

    // borders of dialogs and buttons
    property int borderWidth: 3 * screenProportion
    property int borderRadius: 5 * screenProportion

    // styles for the Weather delegate
    property string forecastTextColor: "white"
    property int forecastCellWidth: 128 * screenProportion
    property int forecastCellHeight: 128 * screenProportion
    property string forecastTempColor: "red"
    property real iconProportionv: 0.9
    property real textSizeDayProportion : 0.13
    property real textSizeForecastProportion : 0.10
    property real textSizeTempProportion : 0.13

    // styles for the clock component
    // the sizes are in proportion to the hight of the clock.
    // There are three borders, text and date.
    // 3*borderProportion+timeTextProportion+dateTextProportion has to be 1.0
    property real borderProportion : 0.1
    property real timeTextProportion : 0.6
    property real dateTextProportion : 0.4
    property string clockFaceColor : "transparent"
    property string offlineClockTextColor : "orange"
    property string onlineClockTextColor : "red"
    property string dateFormat : "dd/MM/yy"
    // alternative date format
    // var dateFormat = "MM/dd/yy"
    property string timeFormat : "hh :mm"

    function calculateWeatherCellWidth(parentWidth){
        var instances = Math.floor(parentWidth/forecastCellWidth);
        var gridWidth = forecastCellWidth*instances;
        var spareSpace = parentWidth - gridWidth
        return (forecastCellWidth + Math.floor(spareSpace / instances)) - 5
    }
}
