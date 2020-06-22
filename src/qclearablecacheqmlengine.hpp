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
#ifndef QCLEARABLECACHEQMLENGINE_HPP
#define QCLEARABLECACHEQMLENGINE_HPP

#include <QQmlApplicationEngine>
#include <QQuickWindow>

class QClearableCacheQmlEngine : public QQmlApplicationEngine
{
    Q_OBJECT

public slots:

    void load(const QString& filePath) {
        QQmlApplicationEngine::load(filePath);
        m_url = QUrl::fromLocalFile( filePath );
    }

    void load(const QUrl& url) {
        QQmlApplicationEngine::load(url);
        m_url = url;
    }

    void close()
    {
        QObject* pRootObject = rootObjects().first();
        Q_ASSERT( pRootObject != NULL );
        QQuickWindow* pMainWindow = qobject_cast<QQuickWindow*>(pRootObject);
        Q_ASSERT( pMainWindow );
        pMainWindow->close();
        pMainWindow->deleteLater();
        for (auto obj : rootObjects())
            obj->deleteLater();
    }

    void reload()
    {

        close();

        clearComponentCache();

        load(m_url);
    }

    void clearCache()
    {
        clearComponentCache();
    }

private:
    QUrl m_url;

};

#endif // QCLEARABLECACHEQMLENGINE_HPP
