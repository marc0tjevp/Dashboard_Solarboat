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
    width: 550
    height: parent.height

    property alias name: mpptNr.text
    property alias status: mpptStatus.text
    property alias indicator: mpptIndicator.state
    property alias voltageInput: mpptVoltageIn.text
    property alias currentInput: mpptCurrentIn.text
    property alias noCharge: mpptNOC.state
    property alias batteryVoltageLevelReached: mpptBNC.state
    property alias overVoltage: mpptOVT.state
    property alias underVoltage: mpptUNDV.state

    property variant statesNames: ["0", "1"]

    Rectangle {
        id: mppt1Container
        x: 10
        y: 10
        width: parent.width - 20
        height: 80
        radius: 5

        Text {
            id: mpptNr
            anchors.left: parent.left
            anchors.leftMargin: 35
            anchors.top: parent.top
            anchors.topMargin: 10
            text: "MPPT 0#"
            font.bold: true
            font.pixelSize: 18
        }
        Rectangle {
            id: mpptNOC
            anchors.left: parent.left
            anchors.leftMargin: 140
            anchors.top: parent.top
            anchors.topMargin: 10
            height: 25
            width: 40
            radius: 3
            color: "grey"
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: mpptNOC; color: "#C6002A"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: mpptNOC; color: "green"}
                    }
                ]
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
            height: 25
            width: 40
            radius: 3
            color: "grey"
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: mpptOVT; color: "#C6002A"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: mpptOVT; color: "green"}
                    }
                ]
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
            height: 25
            width: 40
            radius: 3
            color: "grey"
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: mpptBNC; color: "#C6002A"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: mpptBNC; color: "green"}
                    }
                ]
            Text {
                anchors.centerIn: parent
                text: qsTr("BLVR");
                color: "white"
                font.pixelSize: 12
            }
        }
        Rectangle {
            id: mpptUNDV
            anchors.left: parent.left
            anchors.leftMargin: 185
            anchors.top: parent.top
            anchors.topMargin: 40
            height: 25
            width: 40
            radius: 3
            color: "grey"
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: mpptUNDV; color: "#C6002A"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: mpptUNDV; color: "green"}
                    }
                ]
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
            color: "grey"
            states: [
                    State {
                        name: "1"
                        PropertyChanges { target: mpptIndicator; color: "green"}
                    },
                    State {
                        name: "0"
                        PropertyChanges { target: mpptIndicator; color: "#C6002A"}
                    }
                ]
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
            id: mpptVoltageIn
            anchors.right: parent.right
            anchors.rightMargin: 165
            anchors.top: parent.top
            anchors.topMargin: 15
            text: "0"
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.top: parent.top
            anchors.topMargin: 15
            text: "V"
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
            id: mpptCurrentIn
            anchors.right: parent.right
            anchors.rightMargin: 165
            anchors.top: parent.top
            anchors.topMargin: 45
            text: "0"
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.top: parent.top
            anchors.topMargin: 45
            text: "A"
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: mpptPowerOuput
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            text: ((mpptVoltageIn.text * mpptCurrentIn.text) | 0) + " W"
            font.pixelSize: 25
            font.weight: Font.Black
        }

        Text {
            id: mpptStatus
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 40
            font.pixelSize: 20
            text: "No Status"

        }

    }
}
