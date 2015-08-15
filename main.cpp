#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;
    view.setMinimumSize(QSize(640,480));
    view.setSource(QUrl(QStringLiteral("qrc:/WeatherClock.qml")));

    QObject::connect(view.engine(), SIGNAL(quit()), QGuiApplication::instance(), SLOT(quit()));
    view.show();

    return app.exec();
}
