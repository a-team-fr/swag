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
#include "pdfexporter.h"
#include <QQmlContext>
#include <QTimer>

#include "src/qclearablecacheqmlengine.hpp"
#include "wordprest.h"
#include "networking.h"
#include "modalquery.h"

/**
 * @brief The PrezManager class (the Swag C++ backend, available in QML engine as "pm")
 * This class handle the slide deck and navigation
 */
class PrezManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Wordprest* wp MEMBER m_wp NOTIFY init)
    Q_PROPERTY(WSClient* net MEMBER m_net NOTIFY init)
    Q_PROPERTY(ModalQuery* modalQuery MEMBER m_pMessageBox NOTIFY init)


    /**
     * @brief root of the installation : default applicationDirectory
     */
    Q_PROPERTY(QString installPath READ installPath WRITE setInstallPath  NOTIFY installPathChanged)
    /**
     * @brief where the swag documents are stored : default DocumentsLocation/swag
     */
    Q_PROPERTY(QString slideDecksFolderPath READ slideDecksFolderPath WRITE setSlideDecksFolderPath  NOTIFY slideDecksFolderPathChanged)
    /**
     * @brief when a swag is loaded (i.e currentSlideDeckPath is not empty)
     */
    Q_PROPERTY(bool loaded MEMBER m_loaded NOTIFY prezLoaded)
    /**
     * @brief pendingChanges is true when the swag document has been (potentially) modified since the last saving
     */
    Q_PROPERTY(bool pendingChanges MEMBER m_pendingChanges NOTIFY pendingChangesChanged)
    /**
     * @brief full path to the currently opened swag document
     */
    Q_PROPERTY(QString currentSlideDeckPath MEMBER m_currentSlideDeckPath NOTIFY prezLoaded)
    Q_PROPERTY(QJsonArray lstSlides READ lstSlides NOTIFY slidesReordered)
    Q_PROPERTY(QJsonObject prezProperties MEMBER m_prezProperties NOTIFY prezLoaded)
    Q_PROPERTY(QString defaultBackground READ defaultBackround NOTIFY prezLoaded)
    Q_PROPERTY(QString defaultTextColor READ defaultTextColor NOTIFY prezLoaded)

    Q_PROPERTY(int slideSelected MEMBER m_selectedSlide NOTIFY slideChanged)
    Q_PROPERTY(QString title READ title NOTIFY slideChanged)
    Q_PROPERTY(QUrl displayUrl READ currentDisplay NOTIFY slideChanged)
    Q_PROPERTY(bool isSlideDisplayed READ isSlideDisplayed NOTIFY slideChanged)

    Q_PROPERTY(DisplayType displayType READ displayType WRITE setDisplayType NOTIFY displayTypeChanged)

    Q_PROPERTY(bool showDocumentCode MEMBER m_showDocumentCode WRITE setShowDocumentCode NOTIFY showDocumentCodeChanged)
    Q_PROPERTY(bool showNavigator MEMBER m_showNavigator WRITE setShowNavigator NOTIFY showNavigatorChanged)
    Q_PROPERTY(bool editMode MEMBER m_editMode WRITE setEditMode NOTIFY editModeChanged)
    Q_PROPERTY(bool viewWorldMode MEMBER m_viewWorldMode WRITE setViewWorldMode NOTIFY viewWorldModeChanged)

    Q_PROPERTY(QUrl uploadURL MEMBER m_uploadUrl NOTIFY uploadURLChanged)

    Q_PROPERTY(QStringList lastOpenedFiles MEMBER m_lastOpenedFiles NOTIFY lastOpenedFilesChanged)

    Q_PROPERTY(QQuickItem* currentSlideItem MEMBER m_pCurrentSlideItem NOTIFY currentSlideItemChanged)

public:
    /**
     * @brief The DisplayType enum ( available from QML engine as "PM")
     * If a slide is displayed DisplayType will be either Slide (Slide beeing a generic form), Slide_Loader,Slide_ListView,Slide_FlatView
     * anyother values are for special page (change application settings, export to pdf etc...)
     */
    enum DisplayType{ Slide, Slide_Loader,Slide_ListView,Slide_FlatView,
                      Welcome, GlobalSettings, PrezSettings, SlideSettings, SlideExport, About, WPConnect, WPProfile, NetworkingTest};
    Q_ENUM(DisplayType)


    explicit PrezManager(QObject *parent = nullptr);
    ~PrezManager();

    /**
     * @brief startSwagApp create the QMLEngine and load main.qml document
     */
    void startSwagApp();

signals:
    void init();
    void prezLoaded();
    void slideChanged();
    void displayTypeChanged();
    void slidesReordered();
    void installPathChanged();
    void pendingChangesChanged();
    void slideExported();
    void slideDecksFolderPathChanged();

    void showDocumentCodeChanged();
    void showNavigatorChanged();
    void editModeChanged();
    void viewWorldModeChanged();

    void documentPositionChanged();
    void uploadURLChanged();

    void transfertProgress( const QString& localfilePath, qint64 percProgress, bool upload);
    void transfertCompleted( const QString& localfilePath);

    void lastOpenedFilesChanged();

    void slidePageRatioChanged();

    void currentSlideItemChanged();

    void previousNavigationFocus(bool forceToSlide);
    void nextNavigationFocus(bool forceToSlide);

public slots:

    void hotReload(bool restartApp = false);
    void loginChanged() const;
    /**
     * @brief readFile - low level document reading. It is needed for instance to load styling css by the code element
     * @param documentPath
     * @return file content
     */
    QString readFile(QString documentPath) const;

    bool openSwagExample();
    /**
     * @brief load a swag (high level document reading)
     * @param url : file path to the document to open. If empty, the Gallery will be opened
     * @return false in case of error
     */
    bool openSwag(const QUrl& url);


    bool createSwag(const QUrl& swagDocumentPath);

    bool saveSwag();
    bool closeSwag();


    /**
     * @brief readDocumentProperty - retrieve the value of property name from the swag document json file
     * @param propertyName : name of the property to read
     * @return the property value
     */
    QVariant readDocumentProperty(const QString& propertyName ) const;
    /**
     * @brief writeDocumentProperty - update value of a property from the swag document json file
     * @param propertyName : name of the property to update
     * @param propertyValue : new value
     * @return true if the property value changed
     */
    bool writeDocumentProperty(const QString& propertyName, const QVariant& propertyValue );
    /**
     * @brief readSlideProperty - retrieve the value of property name from the current slide
     * @param propertyName : name of the property to read
     * @return the property value
     */
    QVariant readSlideProperty(const QString& propertyName ) const;
    /**
     * @brief writeSlideProperty - update value of a property from the current slide
     * @param propertyName : name of the property to update
     * @param propertyValue : new value
     * @return true if the property value changed
     */
    bool writeSlideProperty(const QString& propertyName, const QVariant& propertyValue);

    /**
     * @brief startPDFExport (WIP)
     */
    void startPDFExport();
    void addSlidePDFExport(QQuickItem* slide);
    void endPDFExport();


    bool uploadSwag();
    bool downloadSwag(const QUrl& url , int slideIdx = -1);

    void updateCurrentLoadedItem(QQuickItem* pCurrentLoadedItem){
        m_pCurrentSlideItem = nullptr;
        if ( isSlideDisplayed() &&  m_pCurrentSlideItem!= pCurrentLoadedItem)
        {
            m_pCurrentSlideItem = pCurrentLoadedItem;
            emit currentSlideItemChanged();
        }
    }




    /**
     * @brief saveSlide
     * get the update qml code of the current slide and compare with the cache to see if the slide needs to be saved on disk
     * @param code : bypass code to use for saving the slide. If empty, the current slide content will be retrieved
     * @return true when the slide has actually been modifed - or false if not (use cache version of current slide code to determine when the slide needs to be updated)
     */
    bool saveSlide(const QString& code = "");

    QUrl urlSlide(int idxSlide = -1) const;
    QVariantList urlSlides() const;

    double slidePageRatio(int slideIdx = -1) const;

    void selectSlide(int slideIdx);
    QString readSlideQMLCode(int idxSlide = -1) const;

    void changeSlideOrder(int selectedSlide, int newPos);

    void nextSlide( bool ForcetoSlide = true);
    void previousSlide( bool ForcetoSlide = true);

    void createSlide();
    void cloneSlide(int idxSlide = -1);
    void removeSlide(int idxSlide = -1);
    void editSlideSettings(int idxSlide = -1);




    /**
     * @brief lookForLocalFile
     * @param url of the file as entered by the user
     * @return url of the local file path possibly transformed
     */
    QUrl lookForLocalFile(const QString& url) const;


    /**
     * @brief documentUrl
     * @return return a local file path constructed from the installation path
     */
    QUrl documentUrl(const QString& docName, const QString& dir = "src/qml/") const;

    void removeLastOpenedFilesEntry( int index);

private:
    bool openSwag(const QFileInfo& file);

    QString readFile(QUrl documentUrl) const;                                           ///overload provided for conveniency

    mutable QString m_currentSlideQMLCode ="";

    QString installPath() const;
    void setInstallPath(QString newPath) ;


    QString slideDecksFolderPath() const;
    void setSlideDecksFolderPath(const QString& newPath);

    QJsonArray lstSlides() const{ return m_prezProperties.value("slides").toArray();}


    DisplayType m_displayType = Welcome;                    /// cached value of the displayType member
    void  setDisplayType(DisplayType request);              ///
    DisplayType displayType() const;

    QUrl currentDisplay() const;
    bool isSlideDisplayed() const;

    QString title() const;
    QString defaultBackround() const;
    QString defaultTextColor() const;




    bool m_loaded = false;
    QString m_currentSlideDeckPath = QString();

    QString proposeNewNameAvailable(int retry = 0) const;

    QJsonObject m_prezProperties = QJsonObject();
    int m_selectedSlide = 0;

    mutable QSettings m_settings;

    bool m_pendingChanges = false;

    PDFExporter* m_pPDFExporter = nullptr;

    mutable QString m_installPath ="";

    QClearableCacheQmlEngine* m_pEngine = nullptr;

    bool m_isDevelopmentPhase = !QString(SRCDIR).isEmpty();     //

    void setShowDocumentCode(bool mode);
    void setShowNavigator(bool show);
    void setEditMode(bool mode);
    void setViewWorldMode(bool mode);
    bool m_showDocumentCode = false;
    bool m_showNavigator =  true;
    bool m_editMode = false;
    bool m_viewWorldMode = false;

    Wordprest* m_wp = nullptr;
    WSClient* m_net = nullptr;
    ModalQuery* m_pMessageBox = nullptr;

    QUrl m_uploadUrl;

    QStringList m_lastOpenedFiles;

    QQuickItem* m_pCurrentSlideItem = nullptr;

};

#endif
