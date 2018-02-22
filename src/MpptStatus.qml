import QtQuick 2.7
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

Item {
    width: parent.width
    height: parent.height

    property alias name: mpptNr.text
    property alias status: mpptStatus.text
    property alias output: mpptPowerOuput.text
    property alias indicator: mpptIndicator.color

    Rectangle {
        id: mppt1Container
        x: 10
        y: 10
        width: parent.width - 20
        height: 70
        radius: 5

        Text {
            id: mpptNr
            anchors.left: parent.left
            anchors.leftMargin: 35
            anchors.top: parent.top
            anchors.topMargin: 10
            text: qsTr("MPPT")
            font.bold: true
            font.pixelSize: 18
        }
        Rectangle {
            id: mpptNOC
            anchors.left: parent.left
            anchors.leftMargin: 140
            anchors.top: parent.top
            anchors.topMargin: 10
            color: "#C6002A"
            height: 25
            width: 40
            radius: 3
            Text {
                anchors.centerIn: parent
                text: qsTr("NOC");
                color: "white"
                font.pixelSize: 14
            }
        }
        Rectangle {
            id: mpptOVT
            anchors.left: parent.left
            anchors.leftMargin: 140
            anchors.top: parent.top
            anchors.topMargin: 40
            color: "green"
            height: 25
            width: 40
            radius: 3
            Text {
                anchors.centerIn: parent
                text: qsTr("OVT");
                color: "white"
                font.pixelSize: 14
            }
        }
        Rectangle {
            id: mpptBNC
            anchors.left: parent.left
            anchors.leftMargin: 185
            anchors.top: parent.top
            anchors.topMargin: 10
            color: "Green"
            height: 25
            width: 40
            radius: 3
            Text {
                anchors.centerIn: parent
                text: qsTr("BNC");
                color: "white"
                font.pixelSize: 14
            }
        }
        Rectangle {
            id: mpptUNDV
            anchors.left: parent.left
            anchors.leftMargin: 185
            anchors.top: parent.top
            anchors.topMargin: 40
            color: "green"
            height: 25
            width: 40
            radius: 3
            Text {
                anchors.centerIn: parent
                text: qsTr("UNDV");
                color: "white"
                font.pixelSize: 12
            }
        }
        StatusIndicator {
            id: mpptIndicator
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 10
            active: true
            height: 20
            color: "red"
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 235
            anchors.top: parent.top
            anchors.topMargin: 15
            text: qsTr("PV Voltage:");
            font.pixelSize: 14
        }
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.top: parent.top
            anchors.topMargin: 15
            text: mppt.voltageIn + " V"
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 235
            anchors.top: parent.top
            anchors.topMargin: 45
            text: qsTr("PV Current:");
            font.pixelSize: 14
        }
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.top: parent.top
            anchors.topMargin: 45
            text: mppt.currentIn + " A"
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: mpptPowerOuput
            anchors.left: parent.left
            anchors.leftMargin: 420
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("180 W");
            font.pixelSize: 25
            font.weight: Font.Black
        }

        Text {
            id: mpptStatus
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 40
            text: qsTr("Not Charging");

        }

    }
}
