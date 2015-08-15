function getFormattedDateTime(format){
    var date = new Date
    return Qt.formatDateTime(date, format)
}

function f2c(tempInF){
    return (5/9*(tempInF - 32)).toFixed(0)
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
