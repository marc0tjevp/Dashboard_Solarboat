import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.VirtualKeyboard 2.2
import QtLocation 5.6
import QtPositioning 5.6
import QtCharts 2.2
import QlChannelSerial 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: infoBar
    width: parent.width
    height: 40
    color: "#fafafa"
    //color: "#161616"
    antialiasing: true
    anchors.top: parent.top
    anchors.right: parent.right
    border.width: 0
    
    Row{
        height: parent.height
        width: 320
        anchors.right: parent.right
        spacing: 10

        Rectangle {
            height: parent.height
            width: 110
            color: "white"
            Text {
                id: clock
                color: "black"
                text: "00:00:00"
                anchors.centerIn: parent
                font.bold: true
                font.pixelSize: 20

                Timer {
                    id: timer
                    interval: 1000
                    repeat: true
                    running: true

                    onTriggered:
                    {
                        clock.text =  Qt.formatTime(new Date(),"hh:mm:ss");
                    }
                }
            }
        }
        Image {
            id: gpsIcon
            fillMode: Image.PreserveAspectFit
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 5
            state: gps.fix ? "on" : "off"
            states:
                [
                State {
                    name: "on"
                    PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-icon.png"}
                },
                State {
                    name: "off"
                    PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-disconnected.png"}
                }
            ]
        }
        Image {
            id: networkIcon
            fillMode: Image.PreserveAspectFit
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 5
            state: network.internet ? "on" : "off"
            states:
                [
                State {
                    name: "on"
                    PropertyChanges { target: networkIcon; source: "qrc:///img/network-icon.png"}
                },
                State {
                    name: "off"
                    PropertyChanges { target: networkIcon; source: "qrc:///img/network-disconnected.png"}
                }
            ]
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (webEngineViewer.visible)
                    {
                        webEngineViewer.visible = false;
                    } else {
                        webEngineViewer.visible = true;
                    }
                }
            }
        }
        Image {
            id: canbusIcon
            width: 30
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 5
            state: network.canbus ? "on" : "off"
            states:
                [
                State {
                    name: "on"
                    PropertyChanges { target: canbusIcon; source: "qrc:///img/canbus.png"}
                },
                State {
                    name: "off"
                    PropertyChanges { target: canbusIcon; source: "qrc:///img/canbus-disconnected.png"}
                }
            ]
        }

        Rectangle {
            width: 85
            height: 40
            Text {
                id: batterySOCindicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: batteryIcon.left
                text: battery.packSOC + "%"
                font.bold: true
            }
            Image {
                id: batteryIcon
                width: 35
                rotation: -90
                fillMode: Image.PreserveAspectFit
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.right: parent.right
                state: battery.indicator
                states:
                    [
                    State {
                        name: "0"
                        PropertyChanges { target: batteryIcon; source: "qrc:///img/battery1.png"}
                    },
                    State {
                        name: "1"
                        PropertyChanges { target: batteryIcon; source: "qrc:///img/battery2.png"}
                    },
                    State {
                        name: "2"
                        PropertyChanges { target: batteryIcon; source: "qrc:///img/battery3.png"}
                    },
                    State {
                        name: "3"
                        PropertyChanges { target: batteryIcon; source: "qrc:///img/battery4.png"}
                    },
                    State {
                        name: "4"
                        PropertyChanges { target: batteryIcon; source: "qrc:///img/battery5.png"}
                    },
                    State {
                        name: "5"
                        PropertyChanges { target: batteryIcon; source: "qrc:///img/battery6.png"}
                    },
                    State {
                        name: "6"
                        PropertyChanges { target: batteryIcon; source: "qrc:///img/battery7.png"}
                    }

                ]
            }
        }
    }
}
