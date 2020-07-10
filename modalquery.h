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
#ifndef MODALQUERY_H
#define MODALQUERY_H

#include <QObject>

class ModalQuery : public QObject
{
    Q_OBJECT
public:
    explicit ModalQuery(QObject *parent = nullptr);

    uint messageBox(QString titleText, QString contentText, uint buttons);

signals:
    void modalQueryStart(QString titleText, QString contentText, uint buttons);
    void modalQueryEnded();

public slots:
    void modalQueryResponse(uint result){
        m_modalQueryResult = result;
        emit modalQueryEnded();
    }

private :
    uint m_modalQueryResult = -1;
};

#endif // MODALQUERY_H
