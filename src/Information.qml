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
        currentIndex: 1
        anchors.fill: parent
        orientation: Qt.Vertical

        Item {
            id: firstPage

            ChartView {
                title: "Battery Cell-Voltage [V]"
                height: parent.height
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
                height: parent.height - 20
                width: 240
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
                y: 80
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
                y: 160
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
                y: 240
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
        }
    }

    PageIndicator {
        id: indicator

        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }




}
