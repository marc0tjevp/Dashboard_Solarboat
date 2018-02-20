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
    height: parent.height
    width: parent.width

    Rectangle {
        height: 100
        width: 100
        color: "black"
    }
/*
    Slider {
        id: bearingSlider
        x: 16
        y: 13
        width: 125
        height: 48
        orientation: Qt.Horizontal
        stepSize: 1
        to: 360
        value: map.bearing
        onValueChanged:
        {
            map.bearing = bearingSlider.value
            compass.text = Math.round(bearingSlider.value) + "º"

            if((bearingSlider.value >= 0) && (bearingSlider.value < 22)) {
                compassLetter.text = "N"
            } else if ((bearingSlider.value >= 22) && (bearingSlider.value < 67)) {
                compassLetter.text = "NE"
            } else if ((bearingSlider.value >= 67) && (bearingSlider.value < 112)) {
                compassLetter.text = "E"
            } else if ((bearingSlider.value >= 112) && (bearingSlider.value < 157)) {
                compassLetter.text = "ES"
            } else if ((bearingSlider.value >= 157) && (bearingSlider.value < 202)) {
                compassLetter.text = "S"
            } else if ((bearingSlider.value >= 202) && (bearingSlider.value < 247)) {
                compassLetter.text = "SW"
            } else if ((bearingSlider.value >= 247) && (bearingSlider.value < 292)) {
                compassLetter.text = "W"
            } else if ((bearingSlider.value >= 292) && (bearingSlider.value < 337)) {
                compassLetter.text = "WN"
            } else if ((bearingSlider.value >= 337) && (bearingSlider.value <= 360)) {
                compassLetter.text = "N"
            }
        }
    }

    SpinBox {
        id: signalStrength
        x: 16
        y: 55
        width: 125
        height: 39
        //spacing: 6
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
        id: label1
        x: 161
        y: 29
        text: qsTr("Bearing")
    }

    Label {
        id: label2
        x: 161
        y: 60
        text: qsTr("Signal")
    }

    Switch {
        id: gpsSwitch
        x: 15
        y: 100
        text: qsTr("GPS")
        checked: gps.fix
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
        x: 112
        y: 100
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

    TextField {
        id: carrierTxt
        x: 16
        y: 163
        width: 125
        height: 43
        text: network.carrier
        font.letterSpacing: 0
        font.wordSpacing: 0
        onTextChanged: {
            if (activeFocus) {
                inputPanel.visible = activeFocus
                flickable.contentY = carrierTxt.y - 120;
            }
        }
    }

    Button {
        id: setCarrierBtn
        x: 151
        y: 158
        text: qsTr("Set")
        onPressed:
        {
            carrier.text = carrierTxt.text
        }
    }

    SpinBox {
        id: mapZoom
        x: 350
        y: 400
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
        x: 375
        y: 380
        text: qsTr("Zoom level")
    }

    SpinBox {
        id: handleLimit
        x: 0
        y: 400
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
        y: 400
        text: qsTr("Set handle limits")
        onPressed:
        {
            console.info("[INFO] Handle limit set to: " + handleLimit.value + " RPM");
        }
    }

    SpinBox {
        id: motorCurrentLimit
        x: 0
        y: 450
        enabled: true
        stepSize: 1
        scale: 1
        value: 6
        to: 20
        textFromValue: function(value, locale) {
                                   return (value === 1 ? qsTr("%1 Amp")
                                                       : qsTr("%1 Amps")).arg(value);
                          }
    }

    Button {
        id: setMotorLimit
        x: 200
        y: 450
        text: qsTr("Set current limit")
        onPressed:
        {
            console.info("[INFO] Motor current limit set to: " + motorCurrentLimit.value + " Amps");
        }
    }
    */
}
