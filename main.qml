import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2
import QtLocation 5.6
import QtPositioning 5.6
import QtCharts 2.2
import QtQuick.Dialogs 1.2
import QlChannelSerial 1.0


ApplicationWindow {
    visible: true
    width: 800
    height: 480
    color: "#eeeeee"
    property alias controlTab: controlTab
    property alias dashboardTab: dashboardTab
    title: qsTr("Dashboard")
    id: root

    Item {
        id: coord
        property real longitude: 53.051307
        property real latitude: 5.835714
    }
    Item {
        id: motor
        property real rpm: 0
        property real current: 0
    }
    Item {
        id: mppt
        property real name: value
    }


    SwipeView {
        id: swipeView
        width: parent.width * 0.6875
        height: 440
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 40
        currentIndex: tabBar.currentIndex
        interactive: false


        Item {
            id: dashboardTab

            Flickable {
                flickableDirection: Flickable.VerticalFlick
                width: parent.width;
                height: parent.height
                contentWidth: parent.width;
                contentHeight: 1000

                Text {
                    id: txt_RPM
                    x: 0
                    y: 100
                    text: motor.rpm
                }
                Text {
                    id: txt_Current
                    x: 100
                    y: 100
                    text: motor.current
                }

                Image {
                    id: quitButton
                    x: 0
                    y: 400
                    source: "qrc:///img/quit.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.quit()
                        //onClicked: { serialList.append({text: "NEW"})}
                    }
                }
            }
        }

        Item {
            id: controlTab
            Flickable {
                id: flickable
                flickableDirection: Flickable.VerticalFlick
                width: parent.width;
                height: parent.height
                contentWidth: parent.width;
                contentHeight: 1000

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
                    spacing: 6
                    value: 5
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
                    checked: true
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
                    text: qsTr("KPN NL")
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
                    value: 15
                    to: 19
                    onValueChanged:
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
            }
        }

        Item {
            id: connectivityTab

            Flickable {
                flickableDirection: Flickable.VerticalFlick
                width: parent.width;
                height: parent.height
                contentWidth: parent.width;
                contentHeight: 1000

                QlChannelSerial { id:serial }

                ComboBox {
                    id: comboBox13
                    width: 300
                    x: 10
                    y: 0
                    model: comboModel.comboList
                    editable: false
                }
                Button {
                    id: connectSerial
                    text: "Connect"
                    x: 320
                    y: 0
                    width: 110
                    onClicked: {
                        //console.info("[INFO] Connecting to: " + comboBox13.currentText);
                        if (connectSerial.text == "Connect"){
                            connectSerial.text = "Disconnect";
                            serial.open(serial.channels()[comboBox13.currentIndex]);

                            // if success - configure port parameters
                            if (serial.isOpen()){
                                serial.paramSet('baud', '9600');
                                serial.paramSet('bits', '8');
                                serial.paramSet('parity', 'no');
                                serial.paramSet('stops', '0');

                                serial.paramSet('dtr', '0');
                                serial.paramSet('rts', '1');
                            }
                            timer1.start();
                        } else {
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
                    y: 40
                    width: 420
                    height: 100
                    font.pixelSize: 10
                    readOnly: true
                    wrapMode: TextArea.WrapAnywhere
                }
                Timer {
                    id: timer1
                    interval: 200
                    running: false
                    repeat: true
                    onTriggered: {
                        if (serial.isOpen()){

                            var array = serial.readBytes();
                            if (array.length > 357){

                                var result = "";
                                for(var i = 0; i < array.length; ++i){

                                    if (array[i] !== 10)
                                    {
                                        result+= (String.fromCharCode(array[i]));
                                    } else {
                                        serialOutput.text = result;
                                        break;
                                    }
                                }
                                // JSON parser
                            }
                        }
                        // Testing JSON manual
                        var input = '{"motor":{"RPM":1533,"Turning_Direction":false,"Battery_Voltage":41.23,"Current":4.54,"Temp_PCB":23.21,"Temp_Motor":39.25,"Drive_Enable":true,"Drive_Ready":true,"Killswitch_Error":false},"gps":{"latitude":4.744417,"longitude":51.57063,"speed":12.57,"accuracy":0.98,"course":45.00,"fix":false,"sats":6}}';
                        try {
                            var JsonObject= JSON.parse(input);

                            motor.rpm           = JsonObject.motor.RPM;
                            motor.current       = JsonObject.motor.Current;
                            coord.longitude     = JsonObject.gps.longitude;
                            coord.latitude      = JsonObject.gps.latitude;

                        } catch(e) {
                            console.info(e); // error in the above string (in this case, yes)!
                            console.info(result);
                        }
                    }
                }

            }

        }

        Item {
            id: energyTab

            Flickable {
                flickableDirection: Flickable.VerticalFlick
                width: parent.width;
                height: parent.height
                contentWidth: parent.width;
                contentHeight: 1000

                ChartView {
                    height: 300
                    width: parent.width
                    antialiasing: true
                    legend.visible: false

                    SplineSeries {

                        XYPoint { x: 0; y: 0.0 }
                        XYPoint { x: 1.1; y: 3.2 }
                        XYPoint { x: 1.9; y: 2.4 }
                        XYPoint { x: 2.1; y: 2.1 }
                        XYPoint { x: 2.9; y: 2.6 }
                        XYPoint { x: 3.4; y: 2.3 }
                        XYPoint { x: 4.1; y: 3.1 }
                    }
                }
            }
        }
    }

    TabBar {
        id: tabBar
        width: parent.width * 0.6875
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 0
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        currentIndex: swipeView.currentIndex
        TabButton {
            height: 40
            text: qsTr("Dashboard")
        }
        TabButton {
            height: 40
            text: qsTr("Control")
        }
        TabButton {
            height: 40
            text: qsTr("Connectivity")
        }
        TabButton {
            height: 40
            text: qsTr("Energy")
        }
    }

    Plugin {
        id: mapPlugin
        name: "osm"
        PluginParameter {
            name: "osm.mapping.highdpi_tiles"; value: "true"
        }
    }

    Map {
        id: map
        x: 550
        y: 40
        height: parent.height - 40
        antialiasing: false
        tilt: 0
        bearing: 0
        copyrightsVisible: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        plugin: mapPlugin
        center: QtPositioning.coordinate(coord.longitude, coord.latitude)
        zoomLevel: 14
        state: "small"
        states: [
                State {
                    name: "small"
                    PropertyChanges { target: map; width: parent.width * 0.3125}
                },
                State {
                    name: "full"
                    PropertyChanges { target: map; width: parent.width}
                }
            ]

       transitions:
            Transition {
                    PropertyAnimation { properties: "width"; easing.type: Easing.InOutQuad }
                }
       Behavior on center {
         CoordinateAnimation {
           duration: 400
           easing.type: Easing.InOutQuad
          }
       }
        MapCircle {
                id: boatCircle
                center: QtPositioning.coordinate(53.051307, 5.835714)
                radius: 5.0
                color: 'red'
                opacity: 0.8
                border.width: 1
            }


    }

    Button {
        id: fullMap
        x: 751
        y: 432
        width: 50
        height: 50
        text: qsTr("<|>")
        opacity: 0.8
        checked: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 6
        onPressed:
        {
            if(map.state == "small")
            {
                map.state = "full"
            } else {
                map.state = "small"
            }
            //var coord = src.position.coordinate;
            //console.log("Coordinate:", coord.longitude, coord.latitude);
        }
    }

    Rectangle {
        id: infoBar
        x: 550
        y: 0
        width: parent.width * 0.3125
        height: 40
        color: "#fafafa"
        antialiasing: true
        rotation: 0
        transformOrigin: Item.Center
        clip: false
        anchors.top: parent.top
        anchors.right: parent.right
        border.width: 0

        Text {
            id: fixLabel
            x: 70
            y: 27
            width: 50
            color: "#2eaa0c"
            text: qsTr("GPS FIX")
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: modeIndicator
            x: 120
            y: 7
            color: "#000000"
            text: qsTr("3G")
            font.pixelSize: 11
        }

        Text {
            id: carrier
            x: 160
            y: 11
            width: 90
            height: 14
            color: "#000000"
            text: qsTr("ZERO EMISSION")
            anchors.right: parent.right
            anchors.rightMargin: 0
            wrapMode: Text.WordWrap
            anchors.top: parent.top
            anchors.topMargin: 23
            font.pixelSize: 11
        }

        Text {
            id: clock
            x: 160
            y: -10
            color: "#000000"
            text: Qt.formatTime(new Date(), "hh:mm:ss")
            anchors.top: parent.top
            anchors.topMargin: 4
            font.bold: true
            anchors.right: parent.right
            anchors.rightMargin: 10
            font.pixelSize: 16

            Timer {
                id: timer
                interval: 1000
                repeat: true
                running: true

                onTriggered:
                {
                    clock.text =  Qt.formatTime(new Date(),"hh:mm:ss")
                }
            }
        }

        Image {
            id: gpsIcon
            x: 89
            width: 20
            height: 20
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.right: parent.right
            anchors.rightMargin: 141
            state: "connected"
            states:
            [
                State {
                    name: "connected"
                    PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-icon.png"}
                },
                State {
                    name: "disconnected"
                    PropertyChanges { target: gpsIcon; source: "qrc:///img/gps-disconnected.png"}
                }
            ]
        }

        Image {
            id: gsmIcon
            x: 124
            width: 30
            height: 24
            anchors.right: parent.right
            anchors.rightMargin: 96
            anchors.top: parent.top
            anchors.topMargin: 8
            state: "5"
            states:
            [
                State {
                    name: "5"
                    PropertyChanges { target: gsmIcon; source: "qrc:///img/signal5.png"}
                },
                State {
                    name: "4"
                    PropertyChanges { target: gsmIcon; source: "qrc:///img/signal4.png"}
                },
                State {
                    name: "3"
                    PropertyChanges { target: gsmIcon; source: "qrc:///img/signal3.png"}
                },
                State {
                    name: "2"
                    PropertyChanges { target: gsmIcon; source: "qrc:///img/signal2.png"}
                },
                State {
                    name: "1"
                    PropertyChanges { target: gsmIcon; source: "qrc:///img/signal1.png"}
                },
                State {
                    name: "0"
                    PropertyChanges { target: gsmIcon; source: "qrc:///img/signal0.png"}
                }
            ]
        }

        Text {
            id: compassLetter
            x: 31
            width: 39
            height: 14
            text: qsTr("N")
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 180
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }

        Text {
            id: compass
            x: 28
            width: 45
            height: 20
            text: qsTr("0º")
            anchors.top: parent.top
            anchors.topMargin: 19
            anchors.right: parent.right
            anchors.rightMargin: 177
            horizontalAlignment: Text.AlignHCenter
            font.family: "Arial"
            font.bold: true
            font.pixelSize: 16
        }



    }

    InputPanel {
            id: inputPanel
            y: Qt.inputMethod.visible ? parent.height - inputPanel.height : parent.height
            anchors.left: parent.left
            anchors.right: parent.right
            focus: true
            z:100
        }

}


