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
import QtWebEngine 1.5

ApplicationWindow {
    visible: true
    width: 800
    height: 480
    color: "#CCCCCC"
    title: qsTr("Dashboard")

Rectangle {
    id: devForceSize
    color: "#CCCCCC"
    height: 480
    width: 800

    Item {
        id: gps
        property bool   tracking:       true
        property bool   fix:            false
        property real   longitude:      51.589163
        property real   latitude:       4.788127
        property real   speed:          0
        property real   sats:           0
        property real   course:         0
        property real   hdop:           0
    }
    Item {
        id: network
        property real   messages:       0
        property real   errors:         0
        property bool   canbus:         false
        property bool   internet:       false
    }
    Item {
        id: motor
        property real   rpm:            0
        property real   voltage:        0
        property real   current:        0
        property real   power:          (motor.voltage * motor.current) | 0
        property real   temp:           0
        property real   driveReady:     0
        property real   driveEnabled:   0
        property real   killSwitch:     0
        property real   setRPM:         0
        property real   setCurrent:     0
        property real   state:          0
        property real   failSafe:       0
        property real   timeout:        0
        property real   overVoltage:    0
        property real   underVoltage:   0
    }
    Item {
        id: mppt
        property real   totalPower:     (mppt1.power + mppt2.power + mppt3.power + mppt4.power) | 0
    }
    Item {
        id: mppt1
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property real   bvlr:           0
        property real   undv:           0
        property real   ovt:            0
        property real   noc:            0
        property real   power:          (mppt1.voltageIn * mppt1.currentIn) | 0
    }
    Item {
        id: mppt2
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property real   bvlr:           0
        property real   undv:           0
        property real   ovt:            0
        property real   noc:            0
        property real   power:          (mppt2.voltageIn * mppt2.currentIn) | 0
    }
    Item {
        id: mppt3
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property real   bvlr:           0
        property real   undv:           0
        property real   ovt:            0
        property real   noc:            0
        property real   power:          (mppt3.voltageIn * mppt3.currentIn) | 0
    }
    Item {
        id: mppt4
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property real   bvlr:           0
        property real   undv:           0
        property real   ovt:            0
        property real   noc:            0
        property real   power:          (mppt4.voltageIn * mppt4.currentIn) | 0
    }
    Item {
        id: battery
        property real   power:          (battery.packCurrent * battery.packVoltage) | 0
        property real   indicator:      0
        property real   packVoltage:    0
        property real   packCurrent:    0
        property real   packAmphours:   0
        property real   packHighTemp:   0
        property real   packAvgTemp:    0
        property real   packSOC:        0
        property real   packHealth:     0
        property real   highVoltage:    0
        property real   avgVoltage:     0
        property real   lowVoltage:     0
        property real   discharge:      0
        property real   charge:         0
        property real   isCharging:     0
    }

    SwipeView {
        id: swipeView
        width: parent.width
        height: 440
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 40
        currentIndex: tabBar.currentIndex
        interactive: false


        Item {
            id: dashboardTab
             Dashboard {}
        }

        Item {
            id: controlTab
            SystemControl {}
        }

        Item {
            id: detailsTab
            Information {
                id: informationTab
            }
        }
    }

    InfoBar {
        id: infoBar
    }

    TabBar {
        id: tabBar
        width: 480
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 0
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        currentIndex: swipeView.currentIndex
        TabButton {
            height: 40
            text: qsTr("Dashboard")
        }
        TabButton {
            height: 40
            text: qsTr("Settings")
        }
        TabButton {
            height: 40
            text: qsTr("Information")
        }
    }

    WebEngineView {
        id: webEngineViewer
        scale: 1
        x: 0
        visible: false
        anchors.bottom: parent.bottom
        height: 440
        width: parent.width
        url: "http://192.168.8.1"
        zoomFactor: 0.83
    }

//    InputPanel {
//            id: inputPanel
//            y: Qt.inputMethod.visible ? parent.height - inputPanel.height : parent.height
//            anchors.left: parent.left
//            anchors.right: parent.right
//            focus: true
//            z:100
//        }
}
Rectangle{
    anchors.left: devForceSize.right
    height: devForceSize.height
    width: parent.width - devForceSize.width
    color: "#000000"
}
Rectangle{
    x: 0
    anchors.top: devForceSize.bottom
    anchors.bottom: parent.bottom
    width: parent.width
    color: "#000000"
}
}

