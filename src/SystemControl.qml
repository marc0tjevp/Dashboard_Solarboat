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

        SpinBox {
            id: signalStrength
            x: 10
            y: 10
            width: 150
            value: network.mobileSignal
            to: 5
            onValueChanged:
            {
                gsmIcon.state = signalStrength.value
                if (signalStrength.value == 0)
                {
                    modeIndicator.visible = false
                } else {
                    modeIndicator.visible = true
                }
            }
        }
        Label {
            id: label2
            x: 175
            y: 20
            text: qsTr("Signal")
        }

        Switch {
            id: gpsSwitch
            x: 5
            y: 50
            text: qsTr("GPS")
            checked: (gps.fix < 5000 ? true : false)
            onCheckedChanged:
            {
                if(gpsSwitch.checked)
                {
                    fixLabel.text = "GPS FIX"
                    fixLabel.color = "#2eaa0c"
                    gpsIcon.state = "connected"
                } else {
                    fixLabel.text = "NO FIX"
                    fixLabel.color = "#a54208"
                    gpsIcon.state = "disconnected"
                }
            }
        }

        Switch {
            id: gsmModeSwitch
            checked: true
            x: 100
            y: 50
            text: qsTr("3G ONLY")
            onCheckedChanged:
            {
                if(gsmModeSwitch.checked)
                {
                    modeIndicator.text = "3G"
                } else {
                    modeIndicator.text = "2G"
                }
            }
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
            id: mapZoom
            x: 0
            y: 20
            width: 150
            enabled: true
            stepSize: 1
            scale: 1
            value: map.zoomLevel
            to: 20
            onValueModified:
            {
                map.zoomLevel = mapZoom.value
            }
        }
        Text {
            id: label3
            x: 10
            y: 10
            text: qsTr("Zoom level")
            font.pixelSize: 12
        }
        Slider {
            id: bearingSlider
            x: 10
            y: 100
            width: 125
            height: 48
            orientation: Qt.Horizontal
            stepSize: 1
            to: 360
            value: map.bearing
            onValueChanged:
            {
                map.bearing = bearingSlider.value;
            }
        }
        Label {
            id: label1
            x: 10
            y: 80
            text: qsTr("Bearing")
        }

    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 10
        y: 220
        height: 200
        width: parent.width - 20
        radius: 5

        SpinBox {
            id: handleLimit
            x: 0
            y: 100
            enabled: true
            stepSize: 500
            scale: 1
            value: 1500
            to: 4000
            textFromValue: function(value, locale) {
                                       return (qsTr("%1 RPM")).arg(value);
                              }
        }

        Button {
            id: setHandleSpeed
            x: 200
            y: 100
            text: qsTr("Set handle limits")
            onPressed:
            {
                console.info("[INFO] Handle limit set to: " + handleLimit.value + " RPM");
            }
        }

        SpinBox {
            id: motorCurrentLimit
            x: 0
            y: 150
            enabled: true
            stepSize: 1
            scale: 1
            value: 6
            to: 20
            textFromValue: function(value, locale) {return (value === 1 ? qsTr("%1 Amp") : qsTr("%1 Amps")).arg(value);}
        }

        Button {
            id: setMotorLimit
            x: 200
            y: 150
            text: qsTr("Set current limit")
            onPressed:
            {
                console.info("[INFO] Motor current limit set to: " + motorCurrentLimit.value + " Amps");
            }
        }

        Process {
            id: process
            onReadyRead: console.debug(readAll());
        }
        Slider {
            id: brightnessSlider
            x: 16
            y: 10
            width: 200
            height: 48
            orientation: Qt.Horizontal
            stepSize: 1
            from: 11
            to: 255
            value: 255
        }
        Button {
            x: 220
            y: 10
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
