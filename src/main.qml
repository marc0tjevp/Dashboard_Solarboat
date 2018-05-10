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

    Item {
        id: gps
        property bool   tracking:       true
        property bool   fix:            false
        property real   longitude:      51.589163
        property real   latitude:       4.788127
        property real   speed:          23.97
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
        property real   power:          Math.round(motor.voltage * motor.current)
        property real   temp:           0
        property real   driveReady:     0
        property real   driveEnabled:   0
        property real   killSwitch:     0
    }
    Item {
        id: mppt
        property real   totalPower:     mppt1.power + mppt2.power + mppt3.power + mppt4.power
    }

    Item {
        id: mppt1
        property real   currentIn:      1
        property real   voltageIn:      2
        property real   temp:           0
        property real   bvlr:           0
        property real   undv:           0
        property real   ovt:            0
        property real   noc:            0
        property real   power:          (mppt1.voltageIn * mppt1.currentIn) | 0
    }
    Item {
        id: mppt2
        property real   currentIn:      1
        property real   voltageIn:      2
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
            Flickable {
                flickableDirection: Flickable.VerticalFlick
                width: parent.width;
                height: parent.height
                contentWidth: parent.width;
                contentHeight: 1000

                ScrollBar.vertical: ScrollBar { width: 5 }

                ChartView {
                    title: "Battery Cell-Voltage [V]"
                    height: 350
                    x: 0
                    y: 320
                    width: parent.width
                    antialiasing: true
                    legend.visible: false

                    ValueAxis {
                        id: batteryAxisY
                        min: 2.5
                        max: 4.4
                        visible: true
                    }
                    ValueAxis {
                        id: batteryNorm
                        min: 0
                        max: 1
                        visible: false
                    }

                    StackedBarSeries {
                        id: mySeries
                        axisY: batteryAxisY
                        axisX: BarCategoryAxis { categories: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" ] }
                        BarSet { id: batteryBarSet; label: "Cell"; values: [3.1, 3.1, 3.3, 3.8, 3.2, 3.0, 4.0, 4.1, 4.0, 3.2, 3.2, 4.0] }
                    }
                    LineSeries {
                        axisX : batteryNorm
                        XYPoint { x: 0; y: 4.2 }
                        XYPoint { x: 1; y: 4.2 }
                    }
                    LineSeries {
                        axisX : batteryNorm
                        XYPoint { x: 0; y: 2.7 }
                        XYPoint { x: 1; y: 2.7 }
                    }
                }
                Rectangle {
                    y: 650
                    x: 9
                    height: 150
                    width: 532
                    radius: 5

                    ColumnLayout{
                        spacing: 2
                        x: 10
                        Text {
                            font.pixelSize: 14
                            text: "packVoltage \t" + battery.packVoltage
                        }
                        Text {
                            font.pixelSize: 14
                            text: "packCurrent \t" + battery.packCurrent
                        }
                        Text {
                            font.pixelSize: 14
                            text: "packAmphours \t" + battery.packAmphours
                        }
                        Text {
                            font.pixelSize: 14
                            text: "packHighTemp \t" + battery.packHighTemp
                        }
                        Text {
                            font.pixelSize: 14
                            text: "packSOC \t\t" + battery.packSOC
                        }
                        Text {
                            font.pixelSize: 14
                            text: "Dischage EN \t" + battery.discharge
                        }
                        Text {
                            font.pixelSize: 14
                            text: "Charged EN \t" + battery.charge
                        }

                    }
                    ColumnLayout{
                        spacing: 2
                        x: 300

                        Text {
                            font.pixelSize: 14
                            text: "packHealth \t" + battery.packHealth
                        }
                        Text {
                            font.pixelSize: 14
                            text: "highVoltage \t" + battery.highVoltage
                        }
                        Text {
                            font.pixelSize: 14
                            text: "avgVoltage \t" + battery.avgVoltage
                        }
                        Text {
                            font.pixelSize: 14
                            text: "lowVoltage \t" + battery.lowVoltage
                        }
                        Text {
                            font.pixelSize: 14
                            text: "packAvgTemp \t" + battery.packAvgTemp
                        }
                        Text {
                            font.pixelSize: 14
                            text: "isCharging \t" + battery.isCharging
                        }
                    }
                }

                MpptStatus {
                    y: 0
                    name: "MPPT #1"
                    indicator: "none"
                    voltageInput: Math.round(mppt1.voltageIn * 100)/100
                    currentInput: Math.round(mppt1.currentIn * 100)/100
                    status: mppt1.temp
                    noCharge: mppt1.noc
                    batteryVoltageLevelReached: mppt1.bvlr
                    overVoltage: mppt1.ovt
                    underVoltage: mppt1.undv
                }

                MpptStatus {
                    y: 80
                    name: "MPPT #2"
                    voltageInput: Math.round(mppt2.voltageIn * 100)/100
                    currentInput: Math.round(mppt2.currentIn * 100)/100
                    status: mppt2.temp
                    noCharge: mppt2.noc
                    batteryVoltageLevelReached: mppt2.bvlr
                    overVoltage: mppt2.ovt
                    underVoltage: mppt2.undv
                }
                MpptStatus {
                    y: 160
                    name: "MPPT #3"
                    voltageInput: Math.round(mppt3.voltageIn * 100)/100
                    currentInput: Math.round(mppt3.currentIn * 100)/100
                    status: mppt3.temp
                    noCharge: mppt3.noc
                    batteryVoltageLevelReached: mppt3.bvlr
                    overVoltage: mppt3.ovt
                    underVoltage: mppt3.undv
                }
                MpptStatus {
                    y: 240
                    name: "MPPT #4"
                    voltageInput: Math.round(mppt4.voltageIn * 100)/100
                    currentInput: Math.round(mppt4.currentIn * 100)/100
                    status: mppt4.temp
                    noCharge: mppt4.noc
                    batteryVoltageLevelReached: mppt4.bvlr
                    overVoltage: mppt4.ovt
                    underVoltage: mppt4.undv
                }
            }
        }

        Item {
            id: connectivityTab
            Connectivity {}
        }

        Item {
            id: chatTabs
            ChatContainer {}
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
            width: 100
            text: qsTr("Details")
        }
        TabButton {
            height: 40
            width: 100
            text: qsTr("Gateway")
        }
        TabButton {
            height: 40
            width: 60
            text: qsTr("Chat")
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

    InputPanel {
            id: inputPanel
            y: Qt.inputMethod.visible ? parent.height - inputPanel.height : parent.height
            anchors.left: parent.left
            anchors.right: parent.right
            focus: true
            z:100
        }
}


