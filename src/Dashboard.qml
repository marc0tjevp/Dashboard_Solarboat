import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtCharts 2.2
import QtGraphicalEffects 1.0

Item {
    id: dashboard

    height: parent.height
    width: parent.width

    Rectangle {
        x: 10
        y: 10
        height: 120
        width: 200
        radius: 5

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -10
            anchors.right: parent.right
            anchors.rightMargin: 80
            text: (gps.speed | 0)
            font.pixelSize: 90
            font.family: "Arial"
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 115
            color: "#444444"
            text: "," + (gps.speed % 1 * 10 | 0)
            font.pixelSize: 50
            font.family: "Arial"
        }
        Text {
            x: 10
            y: 10
            text: "Km/h"
        }

        Text {
            id: revsMotor
            text: (motor.rpm | 0) + " RPM"
            x: 10
            y: 10
            font.pixelSize: 18
            anchors.right: parent.right
            anchors.rightMargin: 10
            horizontalAlignment: Text.AlignRight
        }
    }

    Rectangle {
        x: 220
        y: 10
        height: 120
        width: 320
        radius: 5

        ChartView {
            legend.visible: false
            antialiasing: true
            margins.top: 0
            margins.bottom: 0
            margins.left: 0
            margins.right: 0
            backgroundColor: "#00000000"
            y: 55
            height: 80
            width: parent.width

            ValueAxis {
                id: axisY
                visible: false
            }

            ValueAxis {
                id: axisX
                visible: false
            }

            HorizontalPercentBarSeries {
                axisX: axisX
                axisY: axisY
                BarSet { id: motorBar; label: "Motor"; values: [motor.power]; color: "#278e89" }
                BarSet { id: solarBar; label: "Solar"; values: [mppt.totalPower]; color: "#54c44a" }
            }
        }
        Text {
            text: Math.round(motor.power) + "W \nMotor"
            x: 15
            y: 85
            font.bold: true
            font.pixelSize: 10
            color: "white"
        }
        Text {
            text: mppt.totalPower + "W \nSolar"
            anchors.right: parent.right
            anchors.rightMargin: 20
            y: 85
            horizontalAlignment: Text.AlignRight
            font.bold: true
            font.pixelSize: 10
            color: "white"
        }
    }

    Rectangle {
        x: 10
        y: 140
        height: 290
        width: 530
        radius: 5

        StatusIndicator {
            id: bms1
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 10
            active: true
            height: 20
            color: "grey"
            state: battery.discharge
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: bms1; color: "green"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: bms1; color: "#C6002A"}
                    }
                ]
        }

        StatusIndicator {
            id: bms2
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 40
            active: true
            height: 20
            color: "grey"
            state: battery.charge
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: bms2; color: "green"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: bms2; color: "#C6002A"}
                    }
                ]
        }

        StatusIndicator {
            id: bms3
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 70
            active: true
            height: 20
            color: "grey"
            state: battery.isCharging
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: bms3; color: "green"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: bms3; color: "#C6002A"}
                    }
                ]
        }

    }
}
