import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtCharts 2.2

Item {
    id: dashboard

    height: parent.height
    width: parent.width

    Rectangle {
        x: 10
        y: 10
        height: 160
        width: 200
        radius: 5

        Text {
            y: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: "15"
            font.pixelSize: 150
            font.family: "Arial"
        }
        Text {
            x: 10
            y: 10
            text: "Km/h"
        }
    }

    ChartView {
        x: 220
        y: 10
        height: 160
        width: 320
        anchors.fill: parent
        antialiasing: true
        legend.visible: false
        margins.top: 0
        margins.bottom: 0
        margins.left: 0
        margins.right: 0


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
        }


        AreaSeries {
            name: "Russian"
            axisX: valueAxis
            axisY: balanceAxis
            upperSeries: LineSeries {
                XYPoint { x: 2000; y: 1 }
                XYPoint { x: 2001; y: 1 }
                XYPoint { x: 2002; y: 1 }
                XYPoint { x: 2003; y: 1 }
                XYPoint { x: 2004; y: 1 }
                XYPoint { x: 2005; y: 0 }
                XYPoint { x: 2006; y: 1 }
                XYPoint { x: 2007; y: 1 }
                XYPoint { x: 2008; y: 4 }
                XYPoint { x: 2009; y: 3 }
                XYPoint { x: 2010; y: 2 }
                XYPoint { x: 2011; y: 1 }
            }
        }
    }

    Rectangle {
        x: 10
        y: 180
        height: 250
        width: 530
        radius: 5
    }
}
