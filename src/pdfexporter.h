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
#ifndef PDFEXPORTER_H
#define PDFEXPORTER_H

#include <QString>
#include <QQuickItem>
#include <QPainter>
#include <QPdfWriter>

class PDFExporter : public QObject
{
public:

    explicit PDFExporter(const QString& fileName, QObject *parent = nullptr);
    virtual ~PDFExporter();

    void exportSlide(QQuickItem* slide);
private:
    void paintItem(QQuickItem *item);//, QPainter *painter);
    void paintText(QQuickItem *text);//, QPainter *painter);
    void paintImage(QQuickItem *image);//, QPainter *painter);
    void paintRectangle(QQuickItem *rect);//, QPainter *painter);

    double m_scaleX =1;
    double m_scaleY = 1;

    QPdfWriter m_pdfWriter;
    QPainter* painter = nullptr;//(&m_pdfWriter);
    bool m_firstPage = true;
};

#endif // PDFEXPORTER_H
