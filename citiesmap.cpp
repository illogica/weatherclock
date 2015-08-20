#include "citiesmap.h"

CitiesMap::CitiesMap(QObject *parent) : QObject(parent)
{
    //Load current location data from Settings
    m_currentCity.setName(settings.value("currentCityName", "Milano,IT").toString());
    m_currentCity.setIdString(settings.value("currentCityId", "3173435").toString());
    emit locationIdChanged(m_currentCity.idString());
    emit locationNameChanged(m_currentCity.name());

    m_modelsLoaded = false;
    emit citiesLoadedChanged(false);
    emit matchesModelChanged(m_matches);
}

QList<QObject*> CitiesMap::matchesModel(){
    return m_matches;
}

void CitiesMap::setMatchesModel(QList<QObject*> newList){
    m_matches = newList;
}

bool CitiesMap::citiesLoaded(){
    return m_modelsLoaded;
}

void CitiesMap::setCitiesLoaded(bool loaded){
    m_modelsLoaded = loaded;
}

void CitiesMap::populateCitiesMap(){
    if(cities.size()>0){
        emit citiesLoadedChanged(true);
        return;
    }

    QFile citiesCsv(":/resources/cities.csv");
    if(citiesCsv.open(QFile::ReadOnly)){
        while(!citiesCsv.atEnd()){
            QString cityLine = citiesCsv.readLine().simplified();
            QStringList split = cityLine.split(";");
            cities.append(split);
        }
        emit citiesLoadedChanged(true);
    } else {
        emit citiesLoadedChanged(false);
    }
}

void CitiesMap::parse(QString name){
    const int MAX_RESULTS = 15;

    if(cities.size()==0){
        return;
    }

    //Loop through all the cities loaded into memory
    QList<QObject*> newMatches;
    for(int i=0; i<cities.length(); i++){
        if(cities[i][1].toLower().contains(name.toLower())){
            newMatches.append(new City(cities[i][1], cities[i][0]));
            if(newMatches.size() >= MAX_RESULTS)
                break;
        }
    }
    if(newMatches.size()==0){
        newMatches.append(new City("Not found", "0"));
    }
    m_matches = newMatches; //memory leak??
    emit matchesModelChanged(m_matches);
}

QString CitiesMap::locationName(){
    return m_currentCity.name();
}

QString CitiesMap::locationId(){
    return m_currentCity.idString();
}

void CitiesMap::setLocationName(QString newLocationName){
    m_currentCity.setName(newLocationName);
    settings.setValue("currentCityName", newLocationName);
    emit locationNameChanged(m_currentCity.name());
}

void CitiesMap::setLocationId(QString newLocationId){
    m_currentCity.setIdString(newLocationId);
    settings.setValue("currentCityId", newLocationId);
    emit locationIdChanged(m_currentCity.idString());
}


