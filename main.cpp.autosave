
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QSerialPort>
#include <QSerialPortInfo>
//#include <QProcess>

#include "comboboxmodel.h"
#include "ql-channel-serial.hpp"



int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    qmlRegisterType<QlChannelSerial>("QlChannelSerial", 1,0, "QlChannelSerial");

    QQmlApplicationEngine engine;
    ComboBoxModel combo;

    QStringList tmp;
    foreach(const QSerialPortInfo &serialPortInfo, QSerialPortInfo::availablePorts()){
          qDebug() << ( serialPortInfo.portName() + " | " + serialPortInfo.description());
          tmp << (serialPortInfo.portName() + " | " + serialPortInfo.description());
    }
    combo.setComboList(tmp);

    QQmlContext *classContext = engine.rootContext();
    classContext->setContextProperty("comboModel", &combo);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    //QProcess process;
    //process.startDetached("sudo shutdown now");

    return app.exec();
}
