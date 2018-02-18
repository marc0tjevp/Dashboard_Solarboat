TEMPLATE = app

QT       += core gui qml serialport
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += src/main.cpp \
    src/comboboxmodel.cpp \
    src/ql-channel.cpp \
    src/ql-channel-serial.cpp

RESOURCES += \
    src/qml.qrc \

QTPLUGIN += qtvirtualkeyboardplugin

# Default rules for deployment.
target.path = /home/pi
INSTALLS += target

disable-xcb {
    message("The disable-xcb option has been deprecated. Please use disable-desktop instead.")
    CONFIG += disable-desktop
}

HEADERS += \
    src/comboboxmodel.h \
    src/ql-channel.hpp \
    src/ql-channel-serial.hpp

DISTFILES += \
    src/main.qml \
    src/DashboardGaugeStyle.qml \
    src/Dashboard.qml \
    src/Control.qml \
    src/Connectivity.qml
