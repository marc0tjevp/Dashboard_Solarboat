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
import "jsonParser.js" as MyScript

Item {
    height: parent.height
    width: parent.width

    Process {
        id: process
        onReadyRead: brightnessSlider.value = parseInt(readAll());
    }
    Process {
        id: commandRunner
        onReadyRead: console.debug(readAll());
    }

    Rectangle {
         x: 10
         y: 10
         width: parent.width - 20
         height: 200
         radius: 5
         color: "white"

         QlChannelSerial { id:serial }

         ComboBox {
             id: comboBox13
             anchors.left: parent.left
             anchors.leftMargin: 10
             anchors.right: connectSerial.left
             anchors.rightMargin: 10
             model: comboModel.comboList
             editable: false
         }
         Button {
             id: connectSerial
             text: "Connect"
             anchors.right: parent.right
             anchors.rightMargin: 10
             width: 110
             onClicked: {
                 if (connectSerial.text == "Connect"){
                     console.info("[INFO] Connecting to: " + comboBox13.currentText);
                     connectSerial.text = "Disconnect";
                     serial.open(serial.channels()[comboBox13.currentIndex]);

                     // if success - configure port parameters
                     if (serial.isOpen()){
                         serial.paramSet('baud', '115200');
                         serial.paramSet('bits', '8');
                         serial.paramSet('parity', 'no');
                         serial.paramSet('stops', '1');
                     }
                     timer1.start();
                 } else {
                     console.info("[INFO] Disconnecting: " + comboBox13.currentText);
                     network.canbus = false;
                     connectSerial.text = "Connect";
                     serial.close(serial.channels()[comboBox13.currentIndex]);
                     serialOutput.text = "";
                     timer1.stop();
                 }
             }
         }
         TextArea {
             id: serialOutput
             x: 10
             y: 45
             width: parent.width -20
             height: 120
             font.pixelSize: 12
             readOnly: true
             wrapMode: TextArea.WrapAnywhere
             placeholderText: "[1] Select the correct device in the dropdown menu.\n[2] Press Connect.\n\nIf the correct device is not shown: Check dmesg + Restart program. \n\nThis system is designed for Gateway Firmware 4.1.2."
         }

         Timer {
             id: timer1
             interval: jsonInterval.value
             running: false
             repeat: true
             onTriggered: { MyScript.func() }
         }

         Text {
             id: jsonMessages
             text: "0"
             x: 10
             y: 170
             font.pixelSize: 12
         }
         Text {
             id: jsonErrors
             text: "0"
             x: 120
             y: 170
             font.pixelSize: 12
         }
         Text {
             id: jsonLength
             text: "0"
             x: 200
             y: 170
             font.pixelSize: 12
         }
         SpinBox {
             id: jsonInterval
             x: 300
             y: 155
             enabled: true
             stepSize: 50
             scale: 0.8
             value: 500
             to: 2000
             width: 150
         }
         Text {
             anchors.left: jsonInterval.right
             anchors.leftMargin: -5
             anchors.verticalCenter: jsonInterval.verticalCenter
             text: "interval [ms]"
             font.pixelSize: 12
         }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 10
        y: 220
        height: 150
        width: parent.width - 20
        radius: 5

        Button {
            id: updateBtn
            text: "Update"
            onReleased: {
                commandRunner.start("cd /home/pi/Dashboard_Solarboat/ && git pull");
            }
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

        Row {
            x:10
            spacing: 10

            Button {
                id: quitButton
                width: 100
                text: "Quit"
                onClicked: Qt.quit()
            }
            Button {
                id: rebootButton
                width: 100
                text: "Reboot"
                onClicked: process.start("sudo reboot");
            }
            Button {
                id: shutdownButton
                width: 100
                text: "Shutdown"
                onClicked: process.start("sudo shutdown now");
            }
        }


        Slider {
            id: brightnessSlider
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: setBrightness.left
            width: 200
            height: 48
            orientation: Qt.Horizontal
            stepSize: 1
            from: 11
            to: 200

            Timer {
                running: true
                repeat: false
                interval: 1000
                onTriggered: {
                    process.start("rpi-backlight --actual-brightness");
                }
            }
        }
        Button {
            id: setBrightness
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            text: "Set Brightness"
            onPressed: { process.start("rpi-backlight -b " + brightnessSlider.value + " -s -d 1"); }
        }
    }
}
