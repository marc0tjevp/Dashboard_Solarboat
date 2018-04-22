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
        width: 30
        height: 30
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 110
        state: gps.fix ? "nofix" : "fix"
        states:
            [
            State {
                name: "fix"
                PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-icon.png"}
            },
            State {
                name: "nofix"
                PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-disconnected.png"}
            }
        ]
    }
    Image {
        id: networkIcon
        width: 30
        height: 30
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 150
        state: gps.fix ? "nofix" : "fix"
        states:
            [
            State {
                name: "fix"
                PropertyChanges { target: networkIcon; source: "qrc:///img/network-icon.png"}
            },
            State {
                name: "nofix"
                PropertyChanges { target: networkIcon; source: "qrc:///img/network-disconnected.png"}
            }
        ]
    }
    Image {
        id: canbusIcon
        width: 30
        height: 30
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 190
        state: gps.fix ? "nofix" : "fix"
        states:
            [
            State {
                name: "fix"
                PropertyChanges { target: canbusIcon; source: "qrc:///img/canbus.png"}
            },
            State {
                name: "nofix"
                PropertyChanges { target: canbusIcon; source: "qrc:///img/canbus-disconnected.png"}
            }
        ]
    }
}
