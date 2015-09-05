#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQuickItem>
#include <QDebug>
#include <QObject>
#include <QQmlContext>
#include <QStringListModel>
#include <QStringList>
#include <QtQml>
//#include "citiesmap.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Illogica Software");
    app.setOrganizationDomain("illogicasoftware.com");
    app.setApplicationName("WeatherClock");

    QQuickView view;
    view.setMinimumSize(QSize(640,480));

    //qmlRegisterSingletonType<CitiesMap>("com.illogica.cities", 1,0, "Cities", CitiesMap::singletontype_provider);

    view.setSource(QUrl(QStringLiteral("qrc:/WeatherClock.qml")));

    QObject::connect(view.engine(), SIGNAL(quit()), QGuiApplication::instance(), SLOT(quit()));
    view.show();

    return app.exec();
}
