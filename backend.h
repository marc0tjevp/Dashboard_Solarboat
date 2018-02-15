#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <QSerialPort>
#include <QSerialPortInfo>

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString serialName READ serialName WRITE setSerialName NOTIFY serialNameChanged)

public:
    explicit BackEnd(QObject *parent = nullptr);

    QString userName();
    QString serialName();
    void setUserName(const QString &userName);
    void setSerialName(const QString &serialName);

signals:
    void userNameChanged();
    void serialNameChanged();

private:
    QString m_userName;
    QString m_serialName;
    void refresh_com();

    QSerialPort *com;
    QByteArray serialData;
    QString serialBuffer;
};

#endif // BACKEND_H
