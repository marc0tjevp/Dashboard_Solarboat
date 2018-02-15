#include "backend.h"
#include <QDebug>
#include <array>

BackEnd::BackEnd(QObject *parent) :
    QObject(parent)
{
    //com = new QSerialPort(this);
    //serialBuffer = "";

    refresh_com();
}

QString BackEnd::userName()
{
    return m_userName;
}
void BackEnd::setUserName(const QString &userName)
{
    if (userName == m_userName)
        return;

    m_userName = userName;
    emit userNameChanged();
}


QString BackEnd::serialName()
{
    return m_serialName;
}
void BackEnd::setSerialName(const QString &serialName)
{
    emit serialNameChanged();
}



void BackEnd::refresh_com()
{
    foreach(const QSerialPortInfo &serialPortInfo, QSerialPortInfo::availablePorts()){
          qDebug() << ( serialPortInfo.portName() + " | " + serialPortInfo.description());
          m_serialName = serialPortInfo.portName();
    }
}
