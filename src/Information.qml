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
                        text: "SOLAR: \t" + mppt.totalPower + "W"
                    }
                    Text {
                        font.pixelSize: 18
                        text: "MOTOR: \t" + motor.power + "W"
                    }
                    Text {
                        font.pixelSize: 18
                        text: "BATT: \t" + battery.power + "W"
                    }
                }

            }

            MpptStatus {
                y: 0
                name: "MPPT #1"
                indicator: "1"
                voltageInput: Math.round(mppt1.voltageIn * 100)/100
                currentInput: Math.round(mppt1.currentIn * 100)/100
                status: mppt1.temp
                noCharge: mppt1.noc
                batteryVoltageLevelReached: mppt1.bvlr
                overVoltage: mppt1.ovt
                underVoltage: mppt1.undv
            }

            MpptStatus {
                y: 90
                name: "MPPT #2"
                indicator: "1"
                voltageInput: Math.round(mppt2.voltageIn * 100)/100
                currentInput: Math.round(mppt2.currentIn * 100)/100
                status: mppt2.temp
                noCharge: mppt2.noc
                batteryVoltageLevelReached: mppt2.bvlr
                overVoltage: mppt2.ovt
                underVoltage: mppt2.undv
            }
            MpptStatus {
                y: 180
                name: "MPPT #3"
                indicator: "1"
                voltageInput: Math.round(mppt3.voltageIn * 100)/100
                currentInput: Math.round(mppt3.currentIn * 100)/100
                status: mppt3.temp
                noCharge: mppt3.noc
                batteryVoltageLevelReached: mppt3.bvlr
                overVoltage: mppt3.ovt
                underVoltage: mppt3.undv
            }
            MpptStatus {
                y: 270
                name: "MPPT #4"
                indicator: "1"
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
                    x: 10
                    y: 10
                    Text {
                        font.pixelSize: 18
                        text: "RPM: \t\t" + motor.rpm
                    }
                    Text {
                        font.pixelSize: 18
                        text: "Voltage: \t\t" + motor.voltage + "V"
                    }
                    Text {
                        font.pixelSize: 18
                        text: "Current: \t\t" + motor.current + "A"
                    }
                    Text {
                        font.pixelSize: 18
                        text: "Power: \t\t" + motor.power + "W"
                    }
                    Text {
                        font.pixelSize: 18
                        text: "Temp: \t\t" + motor.temp
                    }
                    Text {
                        font.pixelSize: 18
                        text: "DriveReady: \t" + motor.driveReady
                    }
                    Text {
                        font.pixelSize: 18
                        text: "DriveEnabled: \t" + motor.driveEnabled
                    }
                    Text {
                        font.pixelSize: 18
                        text: "KisslSwitch: \t" + motor.killSwitch
                    }
                }
            }

            ChartView {
                legend.visible: true
                antialiasing: true
                margins.top: 0
                margins.left: 0
                margins.right: 0
                backgroundColor: "#00000000"
                animationDuration: 100
                animationOptions: ChartView.SeriesAnimations
                x: 300
                y: 10
                height: parent.height - 40
                width: 480

                ValueAxis {
                    id: axisY
                    visible: true
                    tickCount: 8
                    min: 0
                    max: 4000
                }

                ValueAxis {
                    id: axisX
                    visible: true
                }

                LineSeries {
                    name: "Solar"
                    axisX: axisX
                    axisY: axisY
                    XYPoint { x: 2000; y: 300 }
                    XYPoint { x: 2001; y: 312 }
                    XYPoint { x: 2002; y: 568 }
                    XYPoint { x: 2003; y: 587 }
                    XYPoint { x: 2004; y: 534 }
                    XYPoint { x: 2005; y: 523 }
                    XYPoint { x: 2006; y: 222 }
                    XYPoint { x: 2007; y: 289 }
                    XYPoint { x: 2008; y: 245 }
                    XYPoint { x: 2009; y: 212 }
                    XYPoint { x: 2010; y: 211 }
                    XYPoint { x: 2011; y: 200 }
                }
                LineSeries {
                    name: "Solar"
                    axisX: axisX
                    axisY: axisY
                    XYPoint { x: 2000; y: 1267 }
                    XYPoint { x: 2001; y: 1297 }
                    XYPoint { x: 2002; y: 1295 }
                    XYPoint { x: 2003; y: 2633 }
                    XYPoint { x: 2004; y: 2367 }
                    XYPoint { x: 2005; y: 3432 }
                    XYPoint { x: 2006; y: 3454 }
                    XYPoint { x: 2007; y: 3378 }
                    XYPoint { x: 2008; y: 3398 }
                    XYPoint { x: 2009; y: 3411 }
                    XYPoint { x: 2010; y: 2975 }
                    XYPoint { x: 2011; y: 1998 }
                }
                LineSeries {
                    name: "Solar"
                    axisX: axisX
                    axisY: axisY
                    XYPoint { x: 2000; y: 1067 }
                    XYPoint { x: 2001; y: 1097 }
                    XYPoint { x: 2002; y: 1095 }
                    XYPoint { x: 2003; y: 2433 }
                    XYPoint { x: 2004; y: 2167 }
                    XYPoint { x: 2005; y: 3232 }
                    XYPoint { x: 2006; y: 3254 }
                    XYPoint { x: 2007; y: 3178 }
                    XYPoint { x: 2008; y: 3198 }
                    XYPoint { x: 2009; y: 3211 }
                    XYPoint { x: 2010; y: 2775 }
                    XYPoint { x: 2011; y: 1798 }
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
