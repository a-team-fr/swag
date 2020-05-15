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
#ifndef ZIPUTILS_HPP
#define ZIPUTILS_HPP
#include "../deps/miniz-2.1.0/miniz.h"
#include <QDirIterator>

/**
 * @brief The ZipUtils class
 * extremely limited c++ wrapper around minizip lib
 */
class ZipUtils
{
public:
    /**
     * @brief zip : create a zip archive from a given directory
     * @param directoryToArchive - the directory to be zip
     * @param archiveFileName - the desired name of the archive file - if empty, archive file name will be the directory name suffixed with ".zip"
     * @return the QFileInfo of the created archive file or an empty QFileInfo in case of error.
     */
    static QFileInfo zip( const QDir& directoryToArchive, QFileInfo archiveFileName = QFileInfo() )
    {
        if (!directoryToArchive.exists())
            return QFileInfo();

        //use defaut archive file name if not provided
        QFileInfo sourceDir = directoryToArchive.path();
        if ( archiveFileName.path().isEmpty())
            archiveFileName = sourceDir.dir().path() + QDir::separator() + sourceDir.fileName() + ".zip";

        //remove already existing archive if any
        QFile::remove( archiveFileName.path() );

        //get the list of all files to archive
        QFileInfoList lstFiles = directoryToArchive.entryInfoList( QDir::Filter::Files | QDir::Filter::Readable );
        QDirIterator it( directoryToArchive.path(), QDir::Filter::Dirs | QDir::Filter::NoDotAndDotDot,  QDirIterator::Subdirectories);
        while(it.hasNext()) {
            QDir curDir( it.next());
            lstFiles.append( curDir.entryInfoList( QDir::Filter::Files | QDir::Filter::Readable ));
        }

        //initialize mz zip struct
        mz_zip_archive zip_archive;
        memset(&zip_archive, 0, sizeof(zip_archive));

        //Add every file entry to archive
        for (QFileInfo fileInfo : lstFiles)
        {
            QFile file( directoryToArchive.absoluteFilePath( fileInfo.filePath()));
            file.open(QIODevice::ReadOnly);
            QByteArray buf = file.readAll();
            file.close();
            QString filePath = directoryToArchive.relativeFilePath( fileInfo.filePath());
            if (! mz_zip_add_mem_to_archive_file_in_place( archiveFileName.filePath().toStdString().c_str(), filePath.toStdString().c_str(), buf, buf.size(), "", 0, MZ_BEST_COMPRESSION))
                return QFileInfo();

        }

        return archiveFileName;
    }

    /**
     * @brief unzip : extract a zip archive into a given directory
     * @param zipFile : the zip file one wants to extract
     * @param destDir : the desired destination directory, if empty, the zip will be extracted in the directory consisting of its basename
     * @return the QDir of the destination directory or ZipUtils::invalidDir in case of error.
     */
    static QDir unzip(const QFileInfo& zipFile, QDir destDir = invalidDir() )
    {
        if ( !zipFile.exists())
            return invalidDir();

        //default destDir from zipFile filename without extension
        if ( destDir == invalidDir())
            destDir = QDir(zipFile.absolutePath() + QDir::separator() + zipFile.baseName());

        //initialize mz zip struct
        mz_zip_archive zip_archive;
        memset(&zip_archive, 0, sizeof(zip_archive));

        //init zip reader
        if ( !mz_zip_reader_init_file(&zip_archive, zipFile.filePath().toStdString().c_str(), 0))
            return invalidDir();

        // Get and print information about each file in the archive.
        for (int i = 0; i < static_cast<int>( mz_zip_reader_get_num_files(&zip_archive)) ; i++)
        {
            mz_zip_archive_file_stat file_stat;
            if (!mz_zip_reader_file_stat(&zip_archive, i, &file_stat)) continue;
            if (mz_zip_reader_is_file_a_directory(&zip_archive, i)) continue;
            QFileInfo fileName = destDir.path() + QDir::separator() + file_stat.m_filename;

            //make sure extraction path exists
            QDir parentDirectory  = fileName.dir();
            parentDirectory.mkpath( parentDirectory.path() );

            //extract
            if ( !mz_zip_reader_extract_to_file(&zip_archive, i, fileName.filePath().toStdString().c_str(), 0))
            {
                mz_zip_reader_end(&zip_archive);
                return invalidDir();
            }
        }

        // Close zip reader
        mz_zip_reader_end(&zip_archive);

        return destDir;
    }

    /**
     * @brief invalidDir
     * It seems QDir is not defining a builtin value for an invalid directory (the default constructor QDir is returning the current working directory).
     * InvalidDir is thus used when one wants to use a default QDir method parameter or when returning a QDir
     * @return an arbitrary invalid dir path : "invalidDirPath".
     */
    static QDir invalidDir(){
        return QDir("invalidDirPath");
    }



};

#endif // ZIPUTILS_HPP
