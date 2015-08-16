#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Illogica Software");
    app.setOrganizationDomain("illogicasoftware.com");
    app.setApplicationName("WeatherClock");

    QQuickView view;
    view.setMinimumSize(QSize(320,240));
    view.setSource(QUrl(QStringLiteral("qrc:/WeatherClock.qml")));

    QObject::connect(view.engine(), SIGNAL(quit()), QGuiApplication::instance(), SLOT(quit()));
    view.show();

    return app.exec();
}
