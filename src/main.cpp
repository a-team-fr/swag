/****************************************************************************
**
** Copyright (C) 2020 A-Team.
** Contact: https://a-team.fr/
**
** This file is part of the SwagSoftware free project.
**
**  SwagSoftware is free software: you can redistribute it and/or modify
**  it under the terms of the GNU General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**  SwagSoftware is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU General Public License for more details.
**
**  You should have received a copy of the GNU General Public License
**  along with SwagSoftware.  If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/
#include <QGuiApplication>
#include <QApplication>
#include <QQmlContext>
#include <QDebug>
#include <QIcon>
#include "src/qttshelper.hpp"
#include "src/prezmanager.h"
#include "src/qclearablecacheqmlengine.hpp"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("A-Team");
    app.setOrganizationDomain("a-team.fr");
    app.setApplicationName("swag");
    app.setWindowIcon(QIcon(":res/SwagLogo.iconset/icon1024Pr.png"));


    PrezManager prezManager;
    QClearableCacheQmlEngine engine;
    engine.addImportPath( "qrc:/");
    qDebug() << engine.importPathList();

    engine.rootContext()->setContextProperty("appVersion", QString(VERSION)); //QMake defined
    engine.rootContext()->setContextProperty("qmlEngine", &engine);
    QTTSHelper tts( engine.rootContext() );
    qmlRegisterUncreatableType<PrezManager>("fr.ateam.swag", 1, 0, "PM","uncreatable type, only for enum");

    engine.rootContext()->setContextProperty("pm", &prezManager);
    qmlRegisterSingletonType( QUrl("qrc:/src/qml/NavigationSingleton.qml"),"fr.ateam.swag", 1, 0,"NavMan");

    const QUrl url(QStringLiteral("qrc:/src/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}



