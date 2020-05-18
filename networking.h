#ifndef NETWORKING_H
#define NETWORKING_H

#include <QObject>

class Networking : public QObject
{
    Q_OBJECT
public:
    explicit Networking(QObject *parent = nullptr);

signals:

};

#endif // NETWORKING_H
