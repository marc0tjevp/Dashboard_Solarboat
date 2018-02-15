TEMPLATE = app

QT       += core gui qml serialport
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += main.cpp \
    comboboxmodel.cpp \
    ql-channel.cpp \
    ql-channel-serial.cpp

RESOURCES += \
    qml.qrc \

QTPLUGIN += qtvirtualkeyboardplugin

# Default rules for deployment.
target.path = /home/pi
INSTALLS += target

disable-xcb {
    message("The disable-xcb option has been deprecated. Please use disable-desktop instead.")
    CONFIG += disable-desktop
}

HEADERS += \
    comboboxmodel.h \
    ql-channel.hpp \
    ql-channel-serial.hpp

DISTFILES += \
    main.qml \
    DashboardGaugeStyle.qml \
    IconGaugeStyle.qml \
    TachometerStyle.qml \
    ValueSource.qml \
    TurnIndicator.qml
