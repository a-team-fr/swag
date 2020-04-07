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

/**
 * @brief The PrezManager class (the Swag C++ backend, available in QML engine as "pm")
 * This class handle the slide deck and navigation
 */
class PrezManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString installPath READ installPath WRITE setInstallPath  NOTIFY installPathChanged)                                        ///root of the installation : default applicationDirectory
    Q_PROPERTY(QString slideDecksFolderPath READ slideDecksFolderPath WRITE setSlideDecksFolderPath  NOTIFY slideDecksFolderPathChanged)    ///where the swag documents are stored : default DocumentsLocation/swag

    Q_PROPERTY(bool loaded MEMBER m_loaded NOTIFY prezLoaded)                                                                               ///when a swag is load (currentSlideDeckPath is not empty)
    Q_PROPERTY(bool pendingChanges MEMBER m_pendingChanges NOTIFY pendingChangesChanged)

    Q_PROPERTY(QString currentSlideDeckPath MEMBER m_currentSlideDeckPath NOTIFY prezLoaded)                                                //full path to the currently opened swag document

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
    /**
     * @brief The DisplayType enum ( available from QML engine as "PM")
     * If a slide is displayed DisplayType will be either Slide (Slide beeing a generic form), Slide_Loader,Slide_ListView,Slide_FlatView
     * anyother values are for special page (change application settings, export to pdf etc...)
     */
    enum DisplayType{ Slide, Slide_Loader,Slide_ListView,Slide_FlatView,
                      Welcome, GlobalSettings, PrezSettings, SlideSettings, SlideExport, About};
    Q_ENUM(DisplayType)


    explicit PrezManager(QObject *parent = nullptr);
    ~PrezManager();

signals:
    void prezLoaded();
    void slideChanged();
    void displayTypeChanged();
    void slidesReordered();
    void installPathChanged();
    void pendingChangesChanged();
    void slideExported();
    void slideDecksFolderPathChanged();

public slots:
    /**
     * @brief readDocument - low level document reading
     * @param documentPath
     * @return file content
     */
    QString readDocument(QString documentPath) const;
    QString readDocument(QUrl documentUrl) const;                                           ///overload provided for conveniency
    void writeDocument(QUrl documentUrl, const QString&) const;
    void writeSlideDocument(const QString&) const;

    /**
     * @brief startPDFExport (WIP)
     */
    void startPDFExport();
    void addSlidePDFExport(QQuickItem* slide);
    void endPDFExport();

    /**
     * @brief load a swag (high level document reading)
     * @param url : file path to the document to open. If empty, the Gallery will be opened
     * @return false in case of error
     */
    bool load(QString url);
    void unload();

    void savePrezSettings(QString key, QVariant value);
    void saveSlideSettings(QString key, QVariant value);

    QUrl urlSlide(int idxSlide = -1) const;
    QVariantList urlSlides() const;

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

    /**
     * @brief lookForLocalFile
     *
     * @param url of the file as entered by the user
     * @return the file path possibly transformed
     */
    QUrl lookForLocalFile(const QString& url) const;



private:
    QString installPath() const;
    void setInstallPath(QString newPath) ;

    QString slideDecksFolderPath() const;
    void setSlideDecksFolderPath(const QString& newPath);

    QJsonArray lstSlides() const{ return m_prezProperties.value("slides").toArray();}


    /**
     * @brief ressourcePrefix
     * @return return either a file path or qrc uri
     */
    QString ressourcePrefix() const;

    DisplayType m_displayType = Welcome;
    void  setDisplayType(DisplayType request);
    DisplayType displayType() const;

    QUrl currentDisplay() const;
    bool isSlideDisplayed() const;

    /**
     * @brief isSlideFromQrc
     * @return true if url starts with "qrc"
     */
    bool isSlideFromQrc()const;


    QString title() const;
    QString defaultBackround() const;

    bool load(QDir prezFolder);
    bool m_loaded = false;
    QString m_currentSlideDeckPath = QString();
    bool loadGalleryDocument();

    QString proposeNewNameAvailable(int retry = 0) const;

    QJsonObject m_prezProperties = QJsonObject();
    int m_selectedSlide = 0;

    mutable QSettings m_settings;

    bool m_pendingChanges = false;
    QEventLoop loop;

    PDFExporter* m_pPDFExporter = nullptr;
};

#endif
