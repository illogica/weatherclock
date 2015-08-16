function getFormattedDateTime(format){
    var date = new Date
    return Qt.formatDateTime(date, format)
}

function k2c(tempInK){
    return (parseFloat(tempInK) - 273.15).toFixed(1)
}

function k2f(tempInK){
    return ((parseFloat(tempInK)*(9/5))-459.67).toFixed(1)
}

/*
  Return a date from a string like 2015-08-13T15:00:00
  */
function dateFromXmlString(xmlString){
    return xmlString.substring(0,10)
}

/*
  Return a time from a string like 2015-08-13T15:00:00
  */
function timeFromXmlString(xmlString){
    return xmlString.substring(11,16)
}
