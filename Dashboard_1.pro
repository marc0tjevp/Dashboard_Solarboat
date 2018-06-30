TEMPLATE = app

QT       += core gui qml serialport sql webengine
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += src/main.cpp \
    src/comboboxmodel.cpp \
    src/ql-channel.cpp \
    src/ql-channel-serial.cpp \
    src/sqlcontactmodel.cpp \
    src/sqlconversationmodel.cpp

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
    src/ql-channel-serial.hpp \
    src/process.h \
    src/sqlcontactmodel.h \
    src/sqlconversationmodel.h

DISTFILES += \
    src/main.qml \
    src/Dashboard.qml \
    src/Control.qml \
    src/Connectivity.qml \
    src/ChatContainer.qml \
    src/MpptStatus.qml \
    src/SystemControl.qml \
    src/InfoBar.qml
