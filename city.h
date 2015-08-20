#ifndef CITY_H
#define CITY_H

#include <QObject>

class City : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString idString READ idString WRITE setIdString NOTIFY idStringChanged)

public:
    explicit City(QObject *parent = 0);
    City(QString name, QString itemId){m_name = name; m_idString = itemId;}

    QString name(){return m_name;}
    QString idString(){return m_idString;}

    void setName(QString name){m_name = name;}
    void setIdString(QString id){m_idString = id;}

signals:
    void nameChanged(QString newName);
    void idStringChanged(QString newId);

public slots:

private:
    QString m_name;
    QString m_idString;
};

#endif // CITY_H
