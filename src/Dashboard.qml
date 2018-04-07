import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
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
            y: 10
            x: 50
            text: "9"
            font.pixelSize: 100
            font.family: "Arial"
        }
        Text {
            x: 110
            y: 60
            color: "#444444"
            text: ".74"
            font.pixelSize: 50
            font.family: "Arial"
        }
        Text {
            x: 10
            y: 10
            text: "Km/h"
        }
    }

    ChartView {
        x: 212
        y: 2
        height: 135
        width: 335
        antialiasing: true
        backgroundRoundness: 5
        backgroundColor: "#FFFFFF"
        legend.visible: false
        margins.top: 0
        margins.bottom: 0
        margins.left: 0
        margins.right: 0
        //theme: ChartView.ChartThemeDark


        // Define x-axis to be used with the series instead of default one
        ValueAxis {
            id: valueAxis
            min: 2000
            max: 2011
            tickCount: 12
            labelFormat: "%.0f"
            visible: false
        }
        ValueAxis {
            id: balanceAxis
            visible: false
            min: 0
            max: 5
        }
        AreaSeries {
            id: xhart
            name: "balance"
            axisX: valueAxis
            axisY: balanceAxis
            color: "#05aa65"
            upperSeries: LineSeries {
                XYPoint { x: 2000; y: 1;}
                XYPoint { x: 2001; y: 1.2 }
                XYPoint { x: 2002; y: 1 }
                XYPoint { x: 2003; y: 3 }
                XYPoint { x: 2004; y: 2 }
                XYPoint { x: 2005; y: 3.3 }
                XYPoint { x: 2006; y: 4 }
                XYPoint { x: 2007; y: 4.2 }
                XYPoint { x: 2008; y: 4 }
                XYPoint { x: 2009; y: 3.1 }
                XYPoint { x: 2010; y: 2.6 }
                XYPoint { x: 2011; y: 2 }
            }
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
            text: "motor.rpm"
        }
        Text {
            x: 150
            y: 10
            text: Math.round(motor.rpm);
        }
        Text {
            x: 10
            y: 30
            text: "motor.current"
        }
        Text {
            x: 150
            y: 30
            text: Math.round(motor.current * 100) / 100;
        }
        Text {
            x: 10
            y: 50
            text: "motor.tempMTR"
        }
        Text {
            x: 150
            y: 50
            text: motor.tempMTR
        }
        Text {
            x: 10
            y: 80
            text: "motor.driveEnable"
        }
        StatusIndicator {
            x: 140
            y: 80
            active: true
            height: 20
            color: motor.driveEnable ? "grey" : "red"
        }
        Text {
            x: 10
            y: 110
            text: "motor.killSwitch"
        }
        StatusIndicator {
            x: 140
            y: 110
            active: true
            height: 20
            color: motor.killSwitch ? "grey" : "red"
        }
    }
}
