var weatherCurrentBaseUrl = "http://api.openweathermap.org/data/2.5/weather?q=";
var weatherForecastBaseUrl= "http://api.openweathermap.org/data/2.5/forecast?q=";
var weatherCurrentBaseUrlByID = "http://api.openweathermap.org/data/2.5/weather?id=";
var weatherForecastBaseUrlByID = "http://api.openweathermap.org/data/2.5/forecast?id=";

var postFixUrl= "&mode=xml&units=standard&APPID=0ef32cd182e06f2fea084f29872c4128";
var imageBaseUrl= "http://openweathermap.org/img/w/";
var weatherImages = "../resources/weather_icons/";

var citiesSearchBaseUrl = "http://api.openweathermap.org/data/2.5/find?q=";
var citiesSearchPostfix = "&units=metric&mode=xml&APPID=0ef32cd182e06f2fea084f29872c4128";

function getSourceForecast(location){
    var strippedLocation = location.substring(0, location.length - 3);
    return weatherForecastBaseUrl + strippedLocation + postFixUrl;
}

function getSourceCurrent(location){
    var strippedLocation = location.substring(0, location.length - 3);
    return weatherCurrentBaseUrl + strippedLocation + postFixUrl;
}

function getSourceImageUrl(iconId){
    return imageBaseUrl + iconId + ".png";
}

function whichDay(dateString) {
    var daysOfWeek = [qsTr('Sunday'),qsTr('Monday'), qsTr('Tuesday'), qsTr('Wednesday'), qsTr('Thursday'), qsTr('Friday'), qsTr('Saturday')];
    return daysOfWeek[new Date(dateString).getDay()];
}

function calculateCellWidth(parentWidth, cellWidth){
    var instances = Math.floor(parentWidth/cellWidth);
    var gridWidth = cellWidth*instances;
    var spareSpace = parentWidth - gridWidth
    return (cellWidth + Math.floor(spareSpace / instances)) - 3
}

function getWeatherImage(iconId){
    var retValue;
    switch(iconId){
    case("01d"):
        return weatherImages + "sunny.png";
    case("01n"):
        return weatherImages + "clear-night.png";
    case("02d"):
        return weatherImages + "partly_cloudy.png";
    case("02n"):
        return weatherImages + "partly_cloudy_night.png";
    case("03d"):
        return weatherImages + "partly_sunny.png";
    case("03n"):
        return weatherImages + "clouds-night.png";
    case("04d"):
        return weatherImages + "overcast.png";
    case("04n"):
        return weatherImages + "overcast.png";
    case("09d"):
        return weatherImages + "rain.png";
    case("09n"):
        return weatherImages + "rain.png";
    case("10d"):
        return weatherImages + "showers.png";
    case("10n"):
        return weatherImages + "showers-night.png";
    case("11d"):
        return weatherImages + "storm.png";
    case("11n"):
        return weatherImages + "storm-night.png";
    case("13d"):
        return weatherImages + "snow.png";
    case("13n"):
        return weatherImages + "snow-night.png";
    case("50d"):
        return weatherImages + "mist.png";
    case("50n"):
        return weatherImages + "mist.png";
    default:
        return getSourceImageUrl(iconId)
    }
}
