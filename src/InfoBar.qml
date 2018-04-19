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
    width: parent.width * 0.3125
    height: 40
    color: "#fafafa"
    //color: "#161616"
    antialiasing: true
    rotation: 0
    transformOrigin: Item.Center
    clip: false
    anchors.top: parent.top
    anchors.right: parent.right
    border.width: 0
    
    Text {
        id: fixLabel
        x: 50
        y: 27
        width: 50
        color: "#a54208"
        text: qsTr("NO FIX")
        font.pixelSize: 11
        horizontalAlignment: Text.AlignHCenter
    }
    
    Text {
        id: clock
        color: "#000000"
        text: Qt.formatTime(new Date(), "hh:mm:ss")
        anchors.top: parent.top
        anchors.topMargin: 8
        font.bold: true
        anchors.right: parent.right
        anchors.rightMargin: 5
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
    
    Image {
        id: gpsIcon
        width: 20
        height: 20
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.right: parent.right
        anchors.rightMargin: 160
        state: "connected"
        states:
            [
            State {
                name: "connected"
                PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-icon.png"}
            },
            State {
                name: "disconnected"
                PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-disconnected.png"}
            }
        ]
    }
    
    Image {
        id: gsmIcon
        width: 30
        height: 24
        anchors.right: parent.right
        anchors.rightMargin: 110
        anchors.top: parent.top
        anchors.topMargin: 8
        state: network.mobileSignal
        states:
            [
            State {
                name: "5"
                PropertyChanges { target: gsmIcon; source: "qrc:///img/signal5.png"}
            },
            State {
                name: "4"
                PropertyChanges { target: gsmIcon; source: "qrc:///img/signal4.png"}
            },
            State {
                name: "3"
                PropertyChanges { target: gsmIcon; source: "qrc:///img/signal3.png"}
            },
            State {
                name: "2"
                PropertyChanges { target: gsmIcon; source: "qrc:///img/signal2.png"}
            },
            State {
                name: "1"
                PropertyChanges { target: gsmIcon; source: "qrc:///img/signal1.png"}
            },
            State {
                name: "0"
                PropertyChanges { target: gsmIcon; source: "qrc:///img/signal0.png"}
                PropertyChanges { target: modeIndicator; state: "none" }
            }
        ]
    }
    Text {
        id: modeIndicator
        x: 110
        y: 7
        color: "#000000"
        text: ""
        font.pixelSize: 11
        states:
            [
            State {
                name: "none"
                PropertyChanges {
                    target: modeIndicator; text: ""
                    
                }
            },
            State {
                name: "3G"
                PropertyChanges {
                    target: modeIndicator; text: "3G"
                    
                }
            },
            State {
                name: "2G"
                PropertyChanges {
                    target: modeIndicator; text: "2G"
                    
                }
            }
        ]
    }
    
    Text {
        id: batteryStatus
        x: 5
        y: 8
        text: "76%"
        color: "darkgreen"
        font.bold: true
        font.pixelSize: 20
    }
    
    
}
