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
#ifndef PREZMANAGER_H
#define PREZMANAGER_H

#include <QFile>
#include <QDir>
#include <QUrl>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QDebug>
#include <QEventLoop>
#include "pdfexporter.h"


class PrezManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString installPath READ installPath WRITE setInstallPath  NOTIFY installPathChanged)

    Q_PROPERTY(bool loaded MEMBER m_loaded NOTIFY prezLoaded)
    Q_PROPERTY(bool pendingChanges MEMBER m_pendingChanges NOTIFY pendingChangesChanged)

    Q_PROPERTY(QString prezFolderPath MEMBER m_prezFolderPath NOTIFY prezLoaded)

    Q_PROPERTY(QJsonArray lstSlides READ lstSlides NOTIFY slidesReordered)
    Q_PROPERTY(QJsonObject prezProperties MEMBER m_prezProperties NOTIFY prezLoaded)
    Q_PROPERTY(QString defaultBackground READ defaultBackround NOTIFY prezLoaded)

    Q_PROPERTY(int slideSelected MEMBER m_selectedSlide NOTIFY slideChanged)
    Q_PROPERTY(QString title READ title NOTIFY slideChanged)
    Q_PROPERTY(QUrl displayUrl READ currentDisplay NOTIFY slideChanged)
    Q_PROPERTY(bool isSlideDisplayed READ isSlideDisplayed NOTIFY slideChanged)

    Q_PROPERTY(bool isSlideFromQrc READ isSlideFromQrc NOTIFY slideChanged)

    Q_PROPERTY(DisplayType displayType READ displayType WRITE setDisplayType NOTIFY displayTypeChanged)

public:
    enum DisplayType{ Slide, Slide_Loader,Slide_ListView,Slide_FlatView,
                      Welcome, GlobalSettings, PrezSettings, SlideSettings, SlideExport, About};
    Q_ENUM(DisplayType)
    explicit PrezManager(QObject *parent = nullptr);
    ~PrezManager();
    QJsonArray lstSlides() const{ return m_prezProperties.value("slides").toArray();}

    QString installPath() const;
    QString ressourcePrefix() const{
        QString prefix = "qrc:";
        if (!installPath().isEmpty() )
            prefix = "file:"+installPath();
        return prefix;
    }
    QDir moduleImportPath() const{
        QDir mod(installPath()+"/modules");
        if (!mod.exists())
            qDebug() << "Can't find modules in" << mod;
        return mod;
    }
    Q_INVOKABLE QUrl defaultPrezPath() const{
        QDir mod(installPath()+"/prez");
        if (!mod.exists())
            qDebug() << "Can't find default presentation folder in " << mod;

        QUrl url = QUrl::fromLocalFile(mod.absolutePath());
        //qDebug() << url;
        return url;
    }


    /*

    Q_INVOKABLE QString urlToFileName(QUrl url){
        return url.fileName();
    }
    Q_INVOKABLE QString urlToFilePath(QUrl url){
        return url.toLocalFile();
        //return url.path();
    }
    Q_INVOKABLE QUrl filePathToUrl(QString filePath){

        return QUrl::fromLocalFile(filePath);
    }
    */

public slots:
    QString readDocument(QString documentPath) const;
    QString readDocument(QUrl documentUrl) const;
    void writeDocument(QUrl documentUrl, const QString&) const;
    void writeSlideDocument(const QString&) const;

    void startPDFExport();
    void addSlidePDFExport(QQuickItem* slide);
    void endPDFExport();

    //void printPDF();
    //void printPDF_onSlideChanged();

    bool load(QString url){
        QDir tmpDir(url);
        if ( !tmpDir.exists() )
            tmpDir = QDir( QUrl(url).toLocalFile());
        return load( tmpDir);
    }
    void savePrezSettings(QString key, QVariant value);
    void saveSlideSettings(QString key, QVariant value);

    QUrl urlSlide(int idxSlide = -1) const;
    QVariantList urlSlides() const;

    void unload();
    void selectSlide(int slideIdx);
    QString readSlideQMLCode(int idxSlide = -1) const;

    void changeSlideOrder(int selectedSlide, int newPos);

    void nextSlide(){ selectSlide( m_selectedSlide+1); }
    void previousSlide(){ selectSlide( m_selectedSlide-1); }

    void create(QString url);
    void createSlide();
    void cloneSlide(int idxSlide = -1);
    void removeSlide(int idxSlide = -1);
    void editSlide(int idxSlide = -1);


    bool saveToDisk( QString folderPath={}, QJsonObject obj={});

    QUrl lookForLocalFile(const QString& url) const;

signals:
    void prezLoaded();
    void slideChanged();
    void displayTypeChanged();
    void slidesReordered();
    void installPathChanged();
    void pendingChangesChanged();
    void slideExported();

private:

    DisplayType m_displayType = Welcome;
    void  setDisplayType(DisplayType request);
    DisplayType displayType() const;

    QUrl currentDisplay() const;
    bool isSlideDisplayed() const;

    bool isSlideFromQrc()const {
        return urlSlide().scheme()!="qrc";
    }
    void setInstallPath(QString newPath) ;

    QString title() const;
    QString defaultBackround() const;

    bool load(QDir prezFolder);


    bool m_loaded = false;

    QString    m_prezFolderPath = QString();

    QJsonObject m_prezProperties = QJsonObject();
    int m_selectedSlide = 0;

    QSettings m_settings;

    bool m_pendingChanges = false;
    QEventLoop loop;

    PDFExporter* m_pPDFExporter = nullptr;
};

#endif
