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
#include "pdfexporter.h"
#include <QFileDialog>
#include <QPrinter>
#include <QTextDocument>
#include <QPainter>
#include <QQuickItemGrabResult>
#include <QQmlProperty>
#include <QPainterPath>

PDFExporter::PDFExporter(const QString& fileName, QObject *parent ) : QObject(parent), m_pdfWriter(fileName)
{

    m_pdfWriter.setTitle("The whole document");
    m_pdfWriter.setCreator("Anonymous");
    m_pdfWriter.setPdfVersion(QPagedPaintDevice::PdfVersion_1_6);
    m_pdfWriter.setPageSize(QPageSize(QPageSize::A4));
    m_pdfWriter.setPageLayout(QPageLayout(QPageSize(QPageSize::A4),QPageLayout::Landscape,QMarginsF(0, 0, 0, 0)));

    painter = new QPainter(&m_pdfWriter);

}

PDFExporter::~PDFExporter()
{
    if (painter)
        delete painter;
}

void PDFExporter::exportSlide(QQuickItem* slide)
{
    m_pdfWriter.setPageLayout( QPageLayout(QPageSize(QPageSize::A4),QPageLayout::Landscape,QMarginsF(0, 0, 0, 0)));
    m_scaleX = painter->window().width() / slide->width();
    m_scaleY = painter->window().height() / slide->height();
    m_scaleX = m_scaleY  = std::min(m_scaleX,m_scaleY);


    qreal lat = ( painter->window().width() - slide->width() * m_scaleX) / 2;
    qreal vert = ( painter->window().height() - slide->height() * m_scaleY) / 2;
    QTransform transform;
    transform.translate(lat,vert);
    painter->setWorldTransform(transform);
    //if (!m_pdfWriter.setPageMargins( QMarginsF(lat,vert,lat,vert) , QPageLayout::Point )){
    //    qDebug() << "Error when setting margins";
    //}


    if (!m_firstPage) m_pdfWriter.newPage();
    else m_firstPage = false;

    paintItem(slide);
}


void PDFExporter::paintItem(QQuickItem *item)//, QPainter *painter)
{
    if (!item || !item->isVisible())
        return;

    QString className ="";
    if (item->metaObject())
        className = item->metaObject()->className();

    painter->save();
    painter->setOpacity(item->opacity() * painter->opacity());

    painter->setRenderHint(QPainter::Antialiasing);


    QTransform transform;
    transform = painter->transform();
    transform.translate(item->x() * m_scaleX,item->y()*m_scaleY);
    transform.translate(item->width() * m_scaleX / 2,item->height()*m_scaleY/2);
    transform.rotate(item->rotation());
    transform.translate(-item->width() * m_scaleX / 2,-item->height()*m_scaleY/2);
    transform.scale(item->scale(), item->scale());
    painter->setWorldTransform(transform);

    //painter->setViewport(item->x(), item->y(), item->width(), item->height());
    //painter->setWindow(item->x(), item->y(), item->width(), item->height());

    const QRectF itemRect = QRectF{0, 0, item->width() * m_scaleX, item->height() * m_scaleY};

    if (item->clip()) {
        painter->setClipping(true);
        painter->setClipRect( itemRect);//.marginsAdded(QMarginsF(0,0,scaleX,scaleY)));
    }

    if ( !className.isEmpty()){

        //qDebug() << "painting item of type :" << className << "  -z:" << item->z();
        if ( className.startsWith("Label") || className.startsWith("QQuickText"))
        //    qDebug()<<"Label";
        //if ( className.startsWith("Text_"))// className.startsWith("Label") )//|| className.startsWith("Text_"))
        {
            //qDebug() << "painting item of type :" << className << "  -z:" << item->z();
            paintText( item);//, painter);
        }
        else if (className.startsWith("QQuickRectangle"))//( className.startsWith("FAButton") || className.startsWith("QQuickRectangle"))
        {
            //qDebug() << "painting item of type :" << className << "  -z:" << item->z();
            paintRectangle( item);//, painter);
        }
        else if ( className.startsWith("Entity3DElement")
                  || className.startsWith("QQuickImage")
                  || className.startsWith("QDeclarativeGeoMap")
                  || (item->property("elementType").isValid() && (item->property("elementType").toString()=="WebElement"))
                  || (item->property("elementType").isValid() && (item->property("elementType").toString()=="PDFElement"))
                  || (item->property("elementType").isValid() && (item->property("elementType").toString()=="VideoElement"))
                  || (item->property("elementType").isValid() && (item->property("elementType").toString()=="ChartElement"))
                  || (item->property("elementType").isValid() && (item->property("elementType").toString()=="DatavizElement"))
                  ){
            //qDebug() << "painting item of type :" << className << "  -z:" << item->z();
            paintImage( item);//, painter);
        }
        else {
            if (item->property("elementType").isValid())
            qDebug() << "----skipped :" << item->property("elementType");
            else qDebug() << "----skipped :" << className;
        }

    }

    QList<QQuickItem*> zsortedChildren = item->childItems();
    std::sort(std::begin(zsortedChildren ), std::end(zsortedChildren ), [](QQuickItem* a, QQuickItem* b) {return a->z() < b->z(); });
    for (auto child : zsortedChildren)
        paintItem(child);//, painter);//, parentX+item->x(), parentY+item->y());

    painter->restore();
}

void PDFExporter::paintText(QQuickItem *item)//, QPainter *painter)
{
    painter->save();
    QRectF itemRect = QRectF{ 0, 0, item->width() * m_scaleX, item->height() * m_scaleY};

    //QFont font();// = painter->font();
    QString fontFamily = QQmlProperty::read(item, "font.family").toString();
    int fontPointSize = QQmlProperty::read(item, "font.pointSize" ).toInt();
    painter->setFont( QFont(fontFamily,fontPointSize >0 ? fontPointSize : 14) );

    QBrush brush = painter->brush();
    QColor fontColor = QColor(Qt::green);
    QVariant col = item->property("color");
    if (item->property("color").isValid())
        fontColor = QQmlProperty::read(item,"color").value<QColor>();
    brush.setColor( fontColor.toRgb());
    painter->setBrush(brush);

    int flags1 = QQmlProperty::read(item, "alignment").toInt();
    int flags2 = QQmlProperty::read(item, "verticalAlignment").toInt();
    int flags3 = QQmlProperty::read(item, "wrapMode").toInt();
    switch (QQmlProperty::read(item, "wrapMode").toInt())
    {
        case 2:
        case 0: flags3 = Qt::TextSingleLine; break;
        case 1: flags3 = Qt::TextWordWrap; break;
        case 4:
        case 3: flags3 = Qt::TextWrapAnywhere; break;
    default :
        flags3= Qt::TextWrapAnywhere;


    }

    QString textstr = item->property("text").toString();
    painter->drawText( itemRect, flags1 | flags2 | flags3, textstr, &itemRect);


    painter->restore();
}

void PDFExporter::paintRectangle(QQuickItem *item)//, QPainter *painter)
{
    painter->save();
    const QRectF itemRect = QRectF{ 0, 0, item->width() * m_scaleX, item->height() * m_scaleY};

    QQmlProperty border(item, "border");

    if (border.object())
    {
        QColor borderColor( QQmlProperty::read(item, "border.color" ).value<QColor>());
        QBrush brush =painter->brush();
        brush.setStyle(Qt::SolidPattern);
        brush.setColor(borderColor.toRgb());
        double borderWidth = QQmlProperty::read(item, "border.width" ).toReal() * (m_scaleX+m_scaleY)/2;
        QPen outline( brush, borderWidth);
        painter->setPen(outline);
    }

    painter->setRenderHint(QPainter::Antialiasing);
    QPainterPath path;
    double radius = item->property("radius").toReal();
    path.addRoundedRect(itemRect, radius * m_scaleX, radius * m_scaleY);

    painter->fillPath(path, (item->property("color")).value<QColor>());
    painter->drawPath(path);

    painter->restore();
}

void PDFExporter::paintImage(QQuickItem *item)//, QPainter *painter)
{
    painter->save();
    const QRectF itemRect = QRectF{ 0, 0, item->width() * m_scaleX, item->height() * m_scaleY};

    QEventLoop loop;
    QSharedPointer<QQuickItemGrabResult> grabRes = item->grabToImage( );//QSize( itemRect.width(), itemRect.height()) );
    if (!grabRes){
        qDebug() << "error";
    }
    connect(grabRes.data(), &QQuickItemGrabResult::ready, &loop, &QEventLoop::quit);
    /*connect(grabRes.data(), &QQuickItemGrabResult::ready, [=](){
                    painter->drawImage( itemRect, grabRes->image());
                    });*/
    loop.exec();
    painter->drawImage( itemRect, grabRes->image());

    painter->restore();
}
