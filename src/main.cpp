#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "include/translator.h"
#include "include/settings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Translator translator(&engine);
    Settings settings(nullptr);

    engine.rootContext()->setContextProperty("Translator", &translator);
    engine.rootContext()->setContextProperty("Settings", &settings);
    engine.load(QUrl(QStringLiteral("qrc:/qml/resources/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();

}
