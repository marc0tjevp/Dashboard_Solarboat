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
import Process 1.0

Item {
    height: parent.height
    width: parent.width

    Rectangle {
        x: 10
        y: 10
        height: 200
        width: parent.width/2 - 15
        radius: 5

        Switch {
            y: 0
            onCheckedChanged: network.canbus = !network.canbus
        }
        Text {
            y: 15
            x: 60
            text: "CANBUS"
        }

        Switch {
            y: 40
            onCheckedChanged: network.internet = !network.internet
        }
        Text {
            y: 55
            x: 60
            text: "Internet"
        }

        Switch {
            y: 80
            onCheckedChanged: gps.fix = !gps.fix
        }
        Text {
            y: 95
            x: 60
            text: "GSP"
        }


    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 10
        y: 10
        height: 200
        width: parent.width/2 - 15
        radius: 5

        SpinBox {
            id: batterySet
            x: 0
            y: 20
            width: 150
            enabled: true
            stepSize: 1
            scale: 1
            value: 0
            to: 10
            onValueModified:
            {
                battery.packSOC = batterySet.value * 10;

            }
        }
        Switch {
            id: bmsIsCharing
            y: 100
            text: "Charing"
            onCheckedChanged: bmsIsCharing.checked ? battery.isCharging = 1 : battery.isCharging = 0
        }
        Timer{
            interval: 500
            repeat: true
            running: true
            onTriggered: {
                if (battery.isCharging && battery.packSOC <= 20) {
                    battery.indicator = 6;
                } else if(battery.isCharging){
                    battery.indicator = 5;
                } else if(battery.packSOC <= 20){
                    battery.indicator = 0;
                } else if (battery.packSOC <= 40){
                    battery.indicator = 1;
                } else if (battery.packSOC <= 60){
                    battery.indicator = 2;
                } else if (battery.packSOC <= 80){
                    battery.indicator = 3;
                } else if (battery.packSOC <= 100){
                    battery.indicator = 4;
                }
            }
        }

    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 10
        y: 220
        height: 150
        width: parent.width - 20
        radius: 5

        Process {
            id: process
            onReadyRead: console.debug(readAll());
        }
        Slider {
            id: brightnessSlider
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: setBrightness.left
            height: 48
            orientation: Qt.Horizontal
            stepSize: 1
            from: 11
            to: 200
            value: 128
        }
        Button {
            id: setBrightness
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: parent.top
            text: "Set LCD-Brightness"
            onPressed: { process.start("rpi-backlight -b " + brightnessSlider.value + " -s -d 1"); }
        }

    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        height: 50
        width: parent.width - 20
        radius: 5

        Button {
            id: quitButton
            x: 10
            width: 160
            text: "Quit"
            onClicked: Qt.quit()
        }
        Button {
            id: rebootButton
            x: 180
            width: 160
            text: "Reboot"
            onClicked: process.start("sudo reboot");
        }
        Button {
            id: shutdownButton
            x: 350
            width: 170
            text: "Shutdown"
            onClicked: process.start("sudo shutdown now");
        }
    }
}
