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
#include <QCommandLineParser>
#include <QDebug>
#include <QIcon>
#include <QTranslator>
#include "src/prezmanager.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("A-Team");
    app.setOrganizationDomain("a-team.fr");
    app.setApplicationName("swag");
    app.setApplicationVersion(QString(VERSION));
    app.setWindowIcon(QIcon(":/res/SwagLogo.iconset/icon1024.png"));



    QCommandLineParser parser;
    parser.setApplicationDescription("a free presentation system based on Qt");
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addPositionalArgument("swagdoc", QCoreApplication::translate("main", "The swag document (.swag) to open"));
    parser.process(app);
    const QStringList args = parser.positionalArguments();

    PrezManager prezManager;

    //----------- TRANSLATOR
    QTranslator translator;
    //if (true == translator.load(QLocale(), QLatin1String("swag"), QLatin1String("_"), QLatin1String(":/translations")) ) {
    if (translator.load( QLocale(), QLatin1String("swag"), QLatin1String("_"), prezManager.property("installPath").toString()+"/translations")) {
        app.installTranslator(&translator);
    } else {
        qDebug() << "Translator couldn't be loaded [Failed]";
        return 0;
    }
    //----------- TRANSLATOR

    if ( (args.count() > 0) && !args[0].isEmpty())
    {
        qInfo() << "opening from command line :" << args[0];
        prezManager.load( args[0] );
    }

    return app.exec();
}



