#ifndef CITIESMAP_H
#define CITIESMAP_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QFile>
#include <QDebug>
#include <QQmlContext>
#include <QStringList>
#include <QMetaObject>
#include <QSettings>
#include <QByteArray>
#include "city.h"

class CitiesMap : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> matchesModel READ matchesModel WRITE setMatchesModel NOTIFY matchesModelChanged)
    Q_PROPERTY(bool citiesLoaded READ citiesLoaded WRITE setCitiesLoaded NOTIFY citiesLoadedChanged)
    Q_PROPERTY(QString locationName READ locationName WRITE setLocationName NOTIFY locationNameChanged)
    Q_PROPERTY(QString locationId READ locationId WRITE setLocationId NOTIFY locationIdChanged)

public:
    explicit CitiesMap(QObject *parent = 0);
    Q_INVOKABLE void populateCitiesMap();
    Q_INVOKABLE void parse(QString name);

    //Functions for the "matchesModel" property
    QList<QObject*> matchesModel();
    void setMatchesModel(QList<QObject*> newList);

    //Functions for the "citiesLoaded" property
    bool citiesLoaded();
    void setCitiesLoaded(bool loaded);

    //Functions for the "locationName" property
    QString locationName();
    void setLocationName(QString newLocationName);

    //Functions for the "locationId" property
    QString locationId();
    void setLocationId(QString newLocationId);

    //Static constructor to get the singleton instance
    static QObject *singletontype_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        CitiesMap* instance = new CitiesMap();
        return instance;
    }

signals:
    void matchesModelChanged(QList<QObject*> matchesModel);
    void citiesLoadedChanged(bool loaded);      //emitted when file is loaded
    void locationIdChanged(QString newLocationId);
    void locationNameChanged(QString newLocationName);

public slots:

private:
    QList<QStringList> cities;
    QList<QObject*> m_matches;
    bool m_modelsLoaded;
    City m_currentCity;

    QSettings settings;
};

#endif // CITIESMAP_H
