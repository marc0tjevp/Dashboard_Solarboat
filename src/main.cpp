
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QSerialPort>
#include <QSerialPortInfo>
//#include <QProcess>
#include <QSqlDatabase>
#include <QSqlError>
#include <QtQml>

#include "comboboxmodel.h"
#include "ql-channel-serial.hpp"
#include "process.h"
#include "sqlcontactmodel.h"
#include "sqlconversationmodel.h"

static void connectToDatabase()
{
    QSqlDatabase database = QSqlDatabase::database();
    if (!database.isValid()) {
        database = QSqlDatabase::addDatabase("QSQLITE");
        if (!database.isValid())
            qFatal("Cannot add database: %s", qPrintable(database.lastError().text()));
    }

    const QDir writeDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!writeDir.mkpath("."))
        qFatal("Failed to create writable directory at %s", qPrintable(writeDir.absolutePath()));

    // Ensure that we have a writable location on all devices.
    const QString fileName = writeDir.absolutePath() + "/chat-database.sqlite3";
    // When using the SQLite driver, open() will create the SQLite database if it doesn't exist.
    database.setDatabaseName(fileName);
    if (!database.open()) {
        qFatal("Cannot open database: %s", qPrintable(database.lastError().text()));
        QFile::remove(fileName);
    }
}

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    qmlRegisterType<QlChannelSerial>("QlChannelSerial", 1,0, "QlChannelSerial");
    qmlRegisterType<Process>("Process", 1, 0, "Process");
    qmlRegisterType<SqlContactModel>("io.qt.examples.chattutorial", 1, 0, "SqlContactModel");
    qmlRegisterType<SqlConversationModel>("io.qt.examples.chattutorial", 1, 0, "SqlConversationModel");

    connectToDatabase();

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
