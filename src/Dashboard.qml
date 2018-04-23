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
            text: Math.round(gps.speed)
            font.pixelSize: 90
            font.family: "Arial"
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 115
            color: "#444444"
            text: "," + Math.round(gps.speed * 3)
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
            text: Math.round(motor.rpm) + " RPM"
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
                BarSet { id: solarBar; label: "Solar"; values: [160]; color: "#54c44a" }
//                BarSet { label: "James"; values: [100] }
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
            text: 160 + "W \nSolar"
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

        Text {
            x: 10
            y: 10
            text: "Revs"
            font.pixelSize: 12
        }
        Text {
            x: 150
            y: 10
            text: Math.round(motor.rpm);
            font.pixelSize: 12
        }
        Text {
            x: 10
            y: 30
            text: "Current"
            font.pixelSize: 12
        }
        Text {
            x: 150
            y: 30
            text: Math.round(motor.current * 100) / 100;
            font.pixelSize: 12
        }
        Text {
            x: 10
            y: 50
            text: "Motor Temp."
            font.pixelSize: 12
        }
        Text {
            x: 150
            y: 50
            text: motor.temp + " C"
            font.pixelSize: 12
        }
        Text {
            x: 10
            y: 80
            text: "driveEnable"
            font.pixelSize: 12
        }
        StatusIndicator {
            x: 140
            y: 80
            active: true
            height: 15
            color: motor.driveReady ? "green" : "red"
        }
        Text {
            x: 10
            y: 110
            text: "killSwitch"
            font.pixelSize: 12
        }
        StatusIndicator {
            x: 140
            y: 110
            active: true
            height: 15
            color: motor.killSwitch ? "green" : "red"
        }
    }
}
