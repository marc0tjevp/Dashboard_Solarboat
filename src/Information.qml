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

Item {
    height: parent.height
    width: parent.width

    property alias batteryBarSet: batteryBarSet.values

    SwipeView {
        id: view
        anchors.fill: parent
        orientation: Qt.Vertical
        currentIndex: tabBar.currentIndex
        interactive: false

        Item {
            id: firstPage

            ChartView {
                title: "Battery Cell-Voltage [V]"
                height: parent.height - 40
                x: 0
                y: 0
                width: 550
                antialiasing: true
                legend.visible: false

                ValueAxis {
                    id: batteryAxisY
                    min: 2.5
                    max: 4.3
                    visible: true
                }
                ValueAxis {
                    id: batteryNorm
                    min: 0
                    max: 1
                    visible: false
                }

                StackedBarSeries {
                    id: batteryChart
                    axisY: batteryAxisY
                    axisX: BarCategoryAxis { categories: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" ] }
                    BarSet { id: batteryBarSet; label: "Cell"; values: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }
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
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                height: parent.height - 60
                width: 240
                radius: 5

                ColumnLayout{
                    spacing: 5
                    x: 10
                    y: 10
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
                        text: "packSOC \t\t" + battery.packSOC
                    }
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
                        text: "packHighTemp \t" + battery.packHighTemp
                    }
                    Text {
                        font.pixelSize: 14
                        text: "packAvgTemp \t" + battery.packAvgTemp
                    }
                    Text {
                        font.pixelSize: 14
                        text: "isCharging \t" + battery.isCharging
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
            }
        }
        Item {
            id: secondPage

            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                height: parent.height - 60
                width: 240
                radius: 5

                ColumnLayout{
                    spacing: 5
                    x: 10
                    y: 10
                    Text {
                        font.pixelSize: 18
                        text: "SOLAR: \t    " + mppt.totalPower + " W"
                    }
                    Text {
                        font.pixelSize: 18
                        text: "MOTOR:     " + motor.power + " W"
                    }
                    Text {
                        font.pixelSize: 18
                        text: "BATT: \t    " + battery.power + " W"
                    }
                }

            }

            Text {
                anchors.centerIn: mppt1Status
                font.pixelSize: 30
                font.bold: true
                text: "MPPT 1 IS NOT CONNECTED"
            }
            Text {
                anchors.centerIn: mppt2Status
                font.pixelSize: 30
                font.bold: true
                text: "MPPT 2 IS NOT CONNECTED"
            }
            Text {
                anchors.centerIn: mppt3Status
                font.pixelSize: 30
                font.bold: true
                text: "MPPT 3 IS NOT CONNECTED"
            }
            Text {
                anchors.centerIn: mppt4Status
                font.pixelSize: 30
                font.bold: true
                text: "MPPT 4 IS NOT CONNECTED"
            }

            MpptStatus {
                id: mppt1Status
                y: 0
                name: "MPPT #1"
                visible: mppt1.voltageIn > 15 ? true : false
                indicator: ((mppt1.noc + mppt1.bvlr + mppt1.ovt + mppt1.undv) === 0) ? "1" : "0"
                voltageInput: Math.round(mppt1.voltageIn * 100)/100
                currentInput: Math.round(mppt1.currentIn * 100)/100
                status: mppt1.temp
                noCharge: mppt1.noc
                batteryVoltageLevelReached: mppt1.bvlr
                overVoltage: mppt1.ovt
                underVoltage: mppt1.undv
            }

            MpptStatus {
                id: mppt2Status
                y: 100
                name: "MPPT #2"
                visible: mppt2.voltageIn > 15 ? true : false
                indicator: ((mppt2.noc + mppt2.bvlr + mppt2.ovt + mppt2.undv) === 0) ? "1" : "0"
                voltageInput: Math.round(mppt2.voltageIn * 100)/100
                currentInput: Math.round(mppt2.currentIn * 100)/100
                status: mppt2.temp
                noCharge: mppt2.noc
                batteryVoltageLevelReached: mppt2.bvlr
                overVoltage: mppt2.ovt
                underVoltage: mppt2.undv
            }
            MpptStatus {
                id: mppt3Status
                y: 205
                name: "MPPT #3"
                visible: mppt3.voltageIn > 15 ? true : false
                indicator: ((mppt3.noc + mppt3.bvlr + mppt3.ovt + mppt3.undv) === 0) ? "1" : "0"
                voltageInput: Math.round(mppt3.voltageIn * 100)/100
                currentInput: Math.round(mppt3.currentIn * 100)/100
                status: mppt3.temp
                noCharge: mppt3.noc
                batteryVoltageLevelReached: mppt3.bvlr
                overVoltage: mppt3.ovt
                underVoltage: mppt3.undv
            }
            MpptStatus {
                id: mppt4Status
                y: 310
                name: "MPPT #4"
                visible: mppt4.voltageIn > 15 ? true : false
                indicator: ((mppt4.noc + mppt4.bvlr + mppt4.ovt + mppt4.undv) === 0) ? "1" : "0"
                voltageInput: Math.round(mppt4.voltageIn * 100)/100
                currentInput: Math.round(mppt4.currentIn * 100)/100
                status: mppt4.temp
                noCharge: mppt4.noc
                batteryVoltageLevelReached: mppt4.bvlr
                overVoltage: mppt4.ovt
                underVoltage: mppt4.undv
            }
        }
        Item {
            id: thirdPage

            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                height: parent.height - 60
                width: parent.width - 20
                radius: 5

                ColumnLayout{
                    spacing: 5
                    x: 5
                    y: 5
                    Text {
                        font.pixelSize: 20
                        text: "RPM: \t\t" + motor.rpm
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Voltage: \t" + motor.voltage
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Current: \t\t" + motor.current
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Power: \t\t" + motor.power
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Temp Motor: \t" + motor.temp
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Temp PCB: \t" + motor.tempPCB
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Direction: \t" + motor.direction
                    }
                    Text {
                        font.pixelSize: 20
                        text: "DriveReady: \t" + motor.driveReady
                    }
                    Text {
                        font.pixelSize: 20
                        text: "DriveEnabled: \t" + motor.driveEnabled
                    }
                }
                ColumnLayout{
                    spacing: 5
                    x: 400
                    y: 5
                    Text {
                        font.pixelSize: 20
                        text: "Set RPM: \t" + motor.setRPM
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Max Current: \t" + motor.setCurrent
                    }
                    Text {
                        font.pixelSize: 20
                        text: "State: \t\t" + motor.state
                    }
                    Text {
                        font.pixelSize: 20
                        text: "KillSwitch: \t" + motor.killSwitch
                    }
                    Text {
                        font.pixelSize: 20
                        text: "FailSafe: \t" + motor.failSafe
                    }
                    Text {
                        font.pixelSize: 20
                        text: "Timeout: \t" + motor.timeout
                    }
                    Text {
                        font.pixelSize: 20
                        text: "OverVolt.: \t" + motor.overVoltage
                    }
                    Text {
                        font.pixelSize: 20
                        text: "UnderVolt.: \t" + motor.underVoltage
                    }
                }
            }
        }
    }

    TabBar {
        id: tabBar
        width: 800
        height: 40
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
        currentIndex: view.currentIndex
        TabButton {
            height: 40
            text: qsTr("Li-Ion Battery")
        }
        TabButton {
            height: 40
            text: qsTr("Solar Energy")
        }
        TabButton {
            height: 40
            text: qsTr("Electric Motor")
        }
    }




}
