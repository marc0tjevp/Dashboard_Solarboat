#ifndef GPSDECODER_H
#define GPSDECODER_H

#define _USE_MATH_DEFINES

#include <QMainWindow>
#include <QDebug>
#include <QSerialPort>
#include <QSerialPortInfo>


class GPSdecoder : public QObject
{
    Q_OBJECT

public:
    explicit GPSdecoder(QObject *parent);


private slots:


private:

};
#endif // GPSdecoder_H
