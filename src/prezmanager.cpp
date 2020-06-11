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
#include "prezmanager.h"
#include <QJsonDocument>
#include <QUuid>
#include <QQmlEngine>
#include <QQmlContext>
#include <QTimer>
#include <QStandardPaths>

#include "ziputils.hpp"

//#include <filesystem>

PrezManager::PrezManager(QObject *parent) : QObject(parent)
{
    //installPath

    if (m_settings.value("openLastPrezAtStartup").toBool())
    {
        QString pathLastPrezOpened = m_settings.value("pathLastPrezOpened").toString();
        qDebug() << "opened last :" << pathLastPrezOpened;
        if ( !pathLastPrezOpened.isEmpty() )
            load( pathLastPrezOpened +".swag");
    }

    m_wp = new Wordprest(this);

    startSwagApp();
    m_wp->setHostURI( m_settings.value("swagBackend").toString() );

    m_net = new WSClient( this);
    connect( m_wp, &Wordprest::loginChanged, this, &PrezManager::loginChanged);
    connect( m_net, &WSClient::channelChanged, this, &PrezManager::documentPositionChanged);
    connect( this, &PrezManager::documentPositionChanged, m_net, &WSClient::notifyDocumentPositionChanged);

    if (m_settings.value("signinAtStartup").toBool())
        m_wp->logIn( m_settings.value("lastUserName").toString(), m_settings.value("lastPassword").toString());

    emit init();
}
PrezManager::~PrezManager()
{
    if (m_pendingChanges)
        saveToDisk();
    if (m_loaded)
        unload();
    delete m_pEngine;
}



QDir PrezManager::extractSwag(const QString &localfilePath, bool removeFile) const
{
    QDir extractDir = ZipUtils::unzip(localfilePath);
    if (removeFile && extractDir != ZipUtils::invalidDir())
    {
        //cleanup no longer needed swag
        QFile::remove( localfilePath );
    }
    return extractDir;
}


QString PrezManager::compressSwag(const QString& srcDirectoryPath, bool removeDir) const
{
    QFileInfo swag = ZipUtils::zip( srcDirectoryPath, srcDirectoryPath + ".swag" );
    if ( removeDir && ! swag.path().isEmpty() )
    {
        //remove no longer needed extracted folder
        QDir(srcDirectoryPath).removeRecursively();
    }
    return swag.filePath();

}

void PrezManager::reload(bool restartApp )
{
    m_pEngine->clearCache();
    if ( restartApp && m_isDevelopmentPhase)
        startSwagApp();    //Reload everything QML
    else {
        //Reload current QML document
        m_pEngine->clearCache();
        emit slideChanged();
    }
}

void PrezManager::loginChanged() const{
    m_net->onLoginChanged(
                m_wp->property("userId").toUInt(),
                m_wp->property("username").toString());
}

void PrezManager::startSwagApp()
{
    QClearableCacheQmlEngine* pOldEngine = m_pEngine;
    if (pOldEngine)
    {
        pOldEngine->close();
        pOldEngine->deleteLater();
    }


    m_pEngine = new QClearableCacheQmlEngine();
    m_pEngine->addImportPath( documentUrl("","").toLocalFile());
    m_pEngine->addImportPath( "qrc:");

    m_pEngine->rootContext()->setContextProperty("appVersion", QString(VERSION)); //QMake defined

    qmlRegisterUncreatableType<PrezManager>("fr.ateam.swag", 1, 0, "PM","uncreatable type, only for enum");

    m_pEngine->rootContext()->setContextProperty("pm", this);
    qmlRegisterSingletonType( documentUrl("NavigationSingleton.qml"),"fr.ateam.swag", 1, 0,"NavMan");

    m_pEngine->load(documentUrl("main.qml"));

    emit init();

}

void PrezManager::savePrezSettings(QString key, QVariant value)
{
    m_prezProperties.insert(key, QJsonValue::fromVariant( value));

    //Reload
    emit prezLoaded();
    emit slideChanged();

    m_pendingChanges = true;
    emit pendingChangesChanged();
}

void PrezManager::saveSlideSettings(QString key, QVariant value)
{

    QJsonArray slides = lstSlides();
    QJsonObject slide = slides[m_selectedSlide].toObject();
    slide.insert(key, QJsonValue::fromVariant(value));
    slides.replace(m_selectedSlide, slide);
    m_prezProperties.insert("slides", slides);

    //m_showSlideProperty = false;
    emit slideChanged();
    emit slidesReordered();

    m_pendingChanges = true;
    emit pendingChangesChanged();
}


void PrezManager::changeSlideOrder(int selectedSlide, int newPos)
{
    if (selectedSlide == newPos) return;
    newPos = std::max(newPos, 0);
    QJsonArray slides = lstSlides();
    QJsonValue slide = slides.takeAt(selectedSlide);
    newPos = std::min(newPos, slides.count());
    slides.insert(newPos, slide);
    m_prezProperties.insert("slides", slides);
    emit slidesReordered();
    qDebug()<<"ok";

}

QString PrezManager::installPath() const
{
    if (!m_installPath.isEmpty())
        return m_installPath;

    QString sourceDir (SRCDIR);
    if (!sourceDir.isEmpty())
        m_installPath = sourceDir;
    else {
        //fallback
        QDir wd( QCoreApplication::applicationDirPath());
        #ifdef Q_OS_MACOS
        //application is inside swag/bin/swag.app/contents/MacOS
        //wd.cdUp(); wd.cdUp(); wd.cdUp();
        #endif
        #ifdef Q_OS_WINDOWS
        wd.cdUp();
        #endif
        #ifdef Q_OS_LINUX
        wd.cdUp();
        #endif
        //wd.cdUp();

        m_installPath = wd.path();//By default program working directory is supposed to be within "swag/bin" dir
        //m_settings.setValue("installPath", m_installPath);

    }
    qDebug() << "install path is :" << m_installPath;
    return m_installPath;
}

void PrezManager::setInstallPath(QString newPath)
{
    QDir tmpDir(newPath);
    if ( !tmpDir.exists() )
        tmpDir = QDir( QUrl(newPath).toLocalFile());
    if ( !tmpDir.exists() ) return;

    //m_settings.setValue("installPath", tmpDir.path());
    m_installPath = newPath;
    emit installPathChanged();
}

QString PrezManager::slideDecksFolderPath() const
{
    QString ret = m_settings.value("slideDecksFolderPath").toString();
    if (ret.isEmpty()) //fallback
    {
        QDir dir( QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + tr("/Swag") );
        dir.mkpath( dir.path());
        ret = dir.path();
        m_settings.setValue("slideDecksFolderPath", ret);

    }
    return ret;

}

void PrezManager::setSlideDecksFolderPath(const QString& newPath)
{
    QDir tmpDir(newPath);
    if ( !tmpDir.exists() )
        tmpDir = QDir( QUrl(newPath).toLocalFile());
    if ( !tmpDir.exists() ) return;

    m_settings.setValue("slideDecksFolderPath", tmpDir.path());
    emit slideDecksFolderPathChanged();
}



QUrl PrezManager::documentUrl(const QString& docName, const QString& dir) const
{

    return QUrl::fromLocalFile( installPath()+"/"+dir+docName);

}

QString PrezManager::readSlideQMLCode(int idxSlide) const
{
    if (-1 == idxSlide) idxSlide = m_selectedSlide;

    return readDocument( urlSlide( idxSlide ) );
}

QString PrezManager::readDocument(QUrl documentUrl) const
{
    return readDocument(documentUrl.toLocalFile());
}

QString PrezManager::readDocument(QString documentPath) const
{
    QFile file( documentPath );
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
              return QString();
    return file.readAll();
}

void PrezManager::writeDocument(QUrl documentUrl, const QString& newText) const
{
    QFile file( documentUrl.toLocalFile() );
    //QFile file( documentUrl.path() );;
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
              return;

    file.write(newText.toUtf8());
}
void PrezManager::writeSlideDocument(const QString& slideContent) const
{
    QFile file( urlSlide().toLocalFile() );
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
              return;

    file.write(slideContent.toUtf8());
}


bool PrezManager::saveToDisk( QString folderPath, QJsonObject obj)
{
    if (folderPath.isEmpty()) folderPath = m_currentSlideDeckPath;
    if (obj.isEmpty()) obj = m_prezProperties;

    QFile file( folderPath + "/content.json" );
    QJsonDocument doc;
    doc.setObject(obj);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate))
              return false;
    file.write( doc.toJson() );

    m_pendingChanges = false;
    emit pendingChangesChanged();

    return true;
}


QUrl PrezManager::lookForLocalFile(const QString &filePath) const
{
    QFileInfo localFilePath( filePath );

    //If the filePath represents a valid file, then go with it
    if (localFilePath.exists())
        return QUrl::fromLocalFile( localFilePath.filePath());

    //we interpret the filePath as relative from the slide folder of the swag folder
    QString slideFolder = urlSlide().path();
    slideFolder.chop(4);//likely remove ".qml"
    localFilePath.setFile( QUrl::fromLocalFile(  slideFolder + "/" + filePath).toLocalFile() );

    if (localFilePath.exists())
        return QUrl::fromLocalFile(localFilePath.filePath());

    //otherwise we interpret the filePath as relative from the swag folder
    localFilePath.setFile( QUrl::fromLocalFile( m_currentSlideDeckPath+"/" + filePath).toLocalFile() );

    if (localFilePath.exists())
        return QUrl::fromLocalFile(localFilePath.filePath());

    //go with the unmodified url

    return QUrl(filePath);
}

bool PrezManager::loadDirectory(QDir prezFolder)
{
    if (!m_currentSlideDeckPath.isEmpty())
        unload();

    QFile file( prezFolder.path() + "/content.json" );

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return false;
    QJsonDocument doc = QJsonDocument::fromJson( file.readAll());

    if (doc.isNull() || !doc.isObject())
        return false;


    m_prezProperties = doc.object();
    m_currentSlideDeckPath = prezFolder.path();

    //Save path of the prezFolder in history
    m_settings.setValue("pathLastPrezOpened", m_currentSlideDeckPath);
    qDebug() << "saving path for opening next time :" << m_currentSlideDeckPath;

    m_loaded = true;
    setDisplayType(Slide);
    selectSlide(0);
    emit prezLoaded();
    emit slidesReordered();
    emit slideChanged();
    emit documentPositionChanged();
    return true;
}

void PrezManager::unload()
{
    if (!m_loaded) return;

    if (m_pendingChanges)
        saveToDisk();

    compressSwag( m_currentSlideDeckPath);
    m_prezProperties = QJsonObject();
    m_currentSlideDeckPath = QString();
    //m_settings.setValue("pathLastPrezOpened", "");
    m_loaded = false;
    setDisplayType(Welcome);
    emit prezLoaded();
    emit slidesReordered();

    //Slide is updated as a side effect
    m_selectedSlide = -1;
    emit documentPositionChanged();
    emit slideChanged();

    m_uploadUrl =QUrl();
    emit uploadURLChanged();

}

bool PrezManager::uploadPrez()
{
    //do nothing when no document is opened or the user is not connected
    if (!m_loaded || !m_wp->isLoggedIn()) return false;


    QFileInfo swagPath = compressSwag( m_currentSlideDeckPath, false);

    QString uploadSwagName = QString("%1_%2").arg( m_wp->property("userId").toUInt() ).arg( swagPath.fileName() );
    UploadJob* up = new UploadJob( swagPath.filePath(), uploadSwagName);
    connect(up, &UploadJob::finish, this, [=](const QUrl& url){
        m_uploadUrl = url;
        emit uploadURLChanged();
        emit transfertCompleted( swagPath.filePath() );
        emit documentPositionChanged();
        QFile::remove( swagPath.filePath() );
    });

    connect(up, &UploadJob::progressed, this, [=](const QString& localfilePath, qint64 percProgress){
        emit transfertProgress(localfilePath, percProgress, true);
    });
    return true;
}

bool PrezManager::downloadPrez(const QUrl& url, int slideIdx)
{
    //QStringList path = url.path().split("_");
    QString path = url.path();
    int idx = path.indexOf('_');
    Q_ASSERT( idx > 1);
    path.replace(idx, 1, QDir::separator());

    QString localFilePath( slideDecksFolderPath() + path);

    DownloadJob* dlw = new DownloadJob(url, localFilePath);

    connect(dlw, &DownloadJob::finish, this, [=](const QString& localFilePath){
        //save uploadURL to know what document is already downloaded
        m_uploadUrl = url;
        emit uploadURLChanged();
        emit transfertCompleted( localFilePath );
        //load swag
        if (slideIdx >= 0)
        {
            load( QUrl::fromLocalFile( localFilePath ) );
            selectSlide( slideIdx);
        }

    });

    connect(dlw, &DownloadJob::progressed, this, [=](const QString& localfilePath, qint64 percProgress){
        emit transfertProgress(localfilePath, percProgress, false);
    });

    return true;
}

QString PrezManager::title() const
{
    switch(m_displayType)
    {
        case Welcome: return tr("welcome in s🤘ag");
        case About: return tr("About s🤘ag");
        case GlobalSettings: return tr("Settings");
        case WPConnect : return tr("Connection to swagsoftware.net");
        case WPProfile : return tr("Profile");
        case NetworkingTest : return tr("Test WS");

        case PrezSettings: return "Deck Settings";
        case SlideSettings: return "Slide Settings";
        case SlideExport: return "Slides Export";
        case Slide:
        case Slide_Loader:
        case Slide_FlatView:
        case Slide_ListView:
            return ( (m_selectedSlide!=-1) && ( m_selectedSlide < lstSlides().count() ) ) ?
                lstSlides()[m_selectedSlide].toObject().value("title").toString() :
                QString();

    }
    return QString();
}

QString PrezManager::defaultBackround() const
{
    QString background = m_prezProperties.value("defaultBackground").toString();
    if (background.isEmpty())
        background = "import QtQuick 2.0;Rectangle{ color:'lightgray'}";
    return background;

}

QString PrezManager::defaultTextColor() const
{
    QString textColor = m_prezProperties.value("defaultTextColor").toString();
    if (textColor.isEmpty())
        textColor = "black";
    return textColor;

}

void PrezManager::selectSlide(int slideIdx)
{
    if ( (slideIdx < 0) || (slideIdx == m_selectedSlide) || (slideIdx >= lstSlides().count() )) return;
    m_selectedSlide = slideIdx ;

    emit slideChanged();
    emit documentPositionChanged();
}

void PrezManager::setDisplayType(DisplayType request)
{
    m_displayType = request;
    if (m_displayType == Slide)
    {
        m_displayType = Slide_Loader;
        if (m_prezProperties.value("displayMode").toString() == "ListView")
            m_displayType = Slide_ListView;
        else if (m_prezProperties.value("displayMode").toString() == "FlatView")
            m_displayType = Slide_FlatView;

    }

    emit displayTypeChanged();
    emit slideChanged();
}

PrezManager::DisplayType PrezManager::displayType() const
{
    return m_displayType;
}

bool PrezManager::isSlideDisplayed() const{
    return ((m_displayType == Slide_ListView) ||
            (m_displayType == Slide_FlatView) ||
            (m_displayType == Slide_Loader) );
}

QUrl PrezManager::currentDisplay() const
{
    QString prefix = "file:"+installPath()+"/";
    switch(m_displayType)
    {
        case Welcome: return documentUrl("Welcome.qml");
        case About: return documentUrl("About.qml");
        case GlobalSettings: return documentUrl("SettingsPage.qml");
        case WPConnect : return documentUrl("WPConnect.qml");
        case WPProfile : return documentUrl("WPProfile.qml");
        case NetworkingTest : return documentUrl("Networking.qml");
        case PrezSettings: return documentUrl("PrezInfo.qml");
        case SlideSettings: return documentUrl("SlideInfo.qml");
        case SlideExport: return documentUrl("SlidesExporter.qml");

        //Cases where a slide is displayed
        case Slide_ListView:return documentUrl("ListViewDisplay.qml");
    case Slide:
        case Slide_FlatView:return documentUrl("FlatViewDisplay.qml");
        case Slide_Loader: return urlSlide();

    }
    return QUrl();

}

QUrl PrezManager::urlSlide(int idxSlide) const
{
    if (-1 == idxSlide) idxSlide = m_selectedSlide;
    if (-1 == idxSlide) return QUrl();
    if (lstSlides().count() <= idxSlide) return QUrl();

    QJsonObject slide = lstSlides()[idxSlide].toObject();
    QString slideSource = slide.value("source").toString();
    if (slideSource.isEmpty()) return QUrl();

    QString path(m_currentSlideDeckPath + "/" + slideSource);
    //qDebug()<< "showing document:" << path;
    return QUrl::fromLocalFile( path);

}

QVariantList PrezManager::urlSlides() const
{
    QVariantList ret;
    for (int i = 0; i < lstSlides().count(); i++){
        ret.push_back( urlSlide(i));
    }
    return ret;
}

QString PrezManager::proposeNewNameAvailable(int retry) const
{
    QString documentName = retry > 0 ? tr("NewSwag%1.swag").arg(retry) : tr("NewSwag.swag");
    QFileInfo tmpDoc( slideDecksFolderPath() + QDir::separator() + documentName);
    if ( tmpDoc.exists() )
        return proposeNewNameAvailable( retry + 1 );
    return tmpDoc.filePath();
}

void PrezManager::create( const QUrl& swagDocumentPath)
{
    QFileInfo swagDoc = swagDocumentPath.toLocalFile();

    if (swagDoc.path().isEmpty())
        swagDoc = proposeNewNameAvailable();

    QDir tmpDir = swagDoc.dir().path() + QDir::separator()+swagDoc.baseName();
    if ( tmpDir.exists() ){
        //we shouldn't have an existing directory - rename
        tmpDir.rename(tmpDir.path(), tmpDir.path()+"_saved");
    }
    tmpDir.mkpath(tmpDir.path());

    QJsonObject obj;


    obj.insert("title", QJsonValue::fromVariant( tr("New document")));
    obj.insert("displayMode", QJsonValue::fromVariant("Loader"));
    if (m_wp->isLoggedIn())
        obj.insert("author", m_wp->property("username").toString());
    else obj.insert("author", QJsonValue::fromVariant( m_settings.value("profileAuthor").toString() ));
    obj.insert("defaultBackground", QJsonValue::fromVariant( ""));
    obj.insert("defaultTextColor", QJsonValue::fromVariant( "black"));


    obj.insert("materialAccent", QJsonValue::fromVariant( m_settings.value("materialAccent").value<QColor>()));
    obj.insert("materialBackground", QJsonValue::fromVariant( m_settings.value("materialBackground").value<QColor>()));
    obj.insert("materialElevation", QJsonValue::fromVariant( m_settings.value("materialElevation").toInt()));
    obj.insert("materialForeground", QJsonValue::fromVariant( m_settings.value("materialForeground").value<QColor>()));
    obj.insert("materialPrimary", QJsonValue::fromVariant( m_settings.value("materialPrimary").value<QColor>()));
    obj.insert("materialTheme", QJsonValue::fromVariant( m_settings.value("materialTheme").toInt()));


    saveToDisk(tmpDir.path(), obj);
    loadDirectory(tmpDir);

    //There is no point creating a new document without any slide
    createSlide();

    selectSlide(0);
    setDisplayType(Slide);

}

void PrezManager::createSlide()
{
    if (!m_loaded) return;
    QJsonArray slides = lstSlides();
    QJsonObject slide;
    slide.insert("title", QJsonValue::fromVariant( tr("New slide")));
    QString newDocumentPath = QUuid::createUuid().toString()+".qml";
    QFile orig( installPath() + "/src/qml/empty.qml");
    orig.copy( m_currentSlideDeckPath + "/" + newDocumentPath);
    slide.insert("source", QJsonValue::fromVariant(newDocumentPath));
    slide.insert("x", QJsonValue::fromVariant(0));
    slide.insert("y", QJsonValue::fromVariant(0));
    slide.insert("rotation", QJsonValue::fromVariant(0));
    slide.insert("width", QJsonValue::fromVariant(640));
    slide.insert("height", QJsonValue::fromVariant(480));

    slides.append(slide);
    m_prezProperties.insert("slides", slides);

    //Save to disk
    saveToDisk();

    emit slidesReordered();

    //go to the newly created slide
    selectSlide(slides.count()-1);

}

void PrezManager::cloneSlide(int idxSlide)
{
    if (!m_loaded) return;
    if (-1 == idxSlide) idxSlide = m_selectedSlide;

    QJsonArray slides = lstSlides();
    QJsonObject slide = slides[idxSlide].toObject();
    QString newDocumentPath = QUuid::createUuid().toString()+".qml";
    QFile orig(m_currentSlideDeckPath + "/" + slide.value("source").toString());
    orig.copy( m_currentSlideDeckPath + "/" + newDocumentPath);
    slide.insert("source", QJsonValue::fromVariant(newDocumentPath));

    slides.insert(idxSlide, slide);
    m_prezProperties.insert("slides", slides);

    //Save to disk
    saveToDisk();
    emit slidesReordered();

}

void PrezManager::removeSlide(int idxSlide)
{
    if (!m_loaded) return;
    if (-1 == idxSlide) idxSlide = m_selectedSlide;

    QJsonArray slides = lstSlides();
    QString documentPath = slides.takeAt(idxSlide).toObject().value("source").toString();

    QFile::remove( m_currentSlideDeckPath + "/"  + documentPath);
    m_prezProperties.insert("slides", slides);

    //Save to disk
    saveToDisk();

    m_selectedSlide = std::min(m_selectedSlide,slides.count()-1);
    emit slidesReordered();
    emit documentPositionChanged();
}
void PrezManager::editSlide(int idxSlide)
{
    if (!m_loaded) return;
    if (-1 == idxSlide) idxSlide = m_selectedSlide;
    selectSlide(idxSlide);
    setDisplayType(SlideSettings);
    emit slideChanged();

}

void PrezManager::startPDFExport(){
    if (m_pPDFExporter)
        delete m_pPDFExporter;
    m_pPDFExporter = new PDFExporter(m_currentSlideDeckPath + "/export.pdf", this);

}
void PrezManager::addSlidePDFExport(QQuickItem* pSlide)
{
    m_pPDFExporter->exportSlide(pSlide);
    emit slideExported();

}
void PrezManager::endPDFExport(){
    if (m_pPDFExporter)
        delete m_pPDFExporter;
    setDisplayType(Slide);
}


void copyPath(QString src, QString dst)
{
    QDir dir(src);
    if (! dir.exists())
        return;

    foreach (QString d, dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
        QString dst_path = dst + QDir::separator() + d;
        dir.mkpath(dst_path);
        copyPath(src+ QDir::separator() + d, dst_path);
    }

    foreach (QString f, dir.entryList(QDir::Files)) {
        QFile::copy(src + QDir::separator() + f, dst + QDir::separator() + f);
    }
}


bool PrezManager::loadGalleryDocument()
{
    QFile galleryPath( slideDecksFolderPath() + "/gallery.swag");
    //QDir galleryPath( slideDecksFolderPath() + "/Gallery");
    if (!galleryPath.exists())
    {
        //std::filesystem::copy( QString(installPath()+"examples/Gallery").toStdString(), galleryPath.path().toStdString(), std::filesystem::copy_options::recursive);
        //copyPath(installPath()+"/examples/Gallery" , galleryPath.path());
        QFile::copy(installPath()+"/examples/gallery.swag", slideDecksFolderPath() + "/gallery.swag");
    }
    //return load( galleryPath);
    return loadDirectory( extractSwag(slideDecksFolderPath() + "/gallery.swag") );
}

bool PrezManager::load(const QUrl& url)
{
    if (url.isEmpty())
        return loadGalleryDocument();

    QFileInfo file( url.toLocalFile() );
    if ( file.exists() ) {
        return loadDirectory( extractSwag( file.filePath() ));
    }
    else{
        //
        QUrl newUrl = QUrl::fromLocalFile(url.path());
        file = newUrl.toLocalFile( );
        if (file.exists())
            return loadDirectory( extractSwag( file.filePath() ));
    }

    return false;

}

/*
void PrezManager::printPDF_onSlideChanged()
{
    QTimer::singleShot(0, &loop, &QEventLoop::quit);
}

void PrezManager::printPDF()
{
    QQmlEngine qml;
    qml.addImportPath( moduleImportPath().path());
    qmlRegisterUncreatableType<PrezManager>("fr.ateam.swag", 1, 0, "PM","uncreatable type, only for enum");

    qml.rootContext()->setContextProperty("pm", this);
    qmlRegisterSingletonType( QUrl("qrc:/qml/NavigationSingleton.qml"),"fr.ateam.swag", 1, 0,"NavMan");


    QQmlComponent cmpt(&qml, QStringLiteral("qrc:/qml/slideViewer.qml"));
    QObject* viewer = cmpt.create();

    if (!viewer) {
        qDebug() << "Error during creation of slide viewer";
        qDebug() << cmpt.errors();
        return;
    }

    PDFExporter pdf(m_prezFolderPath + "/export.pdf");

    QObject::connect(viewer, SIGNAL(slideChanged()), this, SLOT(printPDF_onSlideChanged()));
    //QObject::connect(viewer, SIGNAL(slideChanged()), &loop, SLOT(quit()));                            //Not working ?

    viewer->setProperty("nbSlides", lstSlides().count());
    long currentSlide = 0;
    for (auto slideInfo : lstSlides()){
        QString slideSource = slideInfo.toObject().value("source").toString();
        viewer->setProperty("currentSlide", QVariant::fromValue(currentSlide++) );
        if (slideSource.isEmpty()) continue;

        qDebug() << "start changing slide";

        viewer->setProperty("slideUrl", QUrl::fromLocalFile( m_prezFolderPath + "/" + slideSource));
        QTimer::singleShot(3000, &loop, &QEventLoop::quit);                                            //timeout
        loop.exec();                                                                                    //Wait until quit from "printPDF_onSlideChanged" or QTimer timeout

        qDebug() << "get slide";

        QQuickItem* pSlide = viewer->property("slide").value<QQuickItem*>();

        qDebug() << "start slide export";
        if (pSlide)
            pdf.exportSlide(pSlide);
        else qDebug() << "Error when trying to retrieve slide";
        qDebug() << "done";

    }

    QMetaObject::invokeMethod(viewer, "close");
    delete viewer;

}
*/

