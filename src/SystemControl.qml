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
                 console.info("[INFO] Connecting to: " + comboBox13.currentText);
                 if (connectSerial.text == "Connect"){
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
             placeholderText: "[1] Select the correct device in the dropdown menu.\n[2] Press Connect.\n\nIf the correct device is not shown: Check dmesg + Restart program. \n\nThis system is designed for Gateway Firmware 4.2.1."
         }

         function readCAN() {
             if (serial.isOpen()){

                 var array = serial.readBytes();
                 var result = "";
                 var beginFound = false;
                 if (array.length > 150){
                     network.messages++;
                     jsonMessages.text = "Messages: " + network.messages;

                     for(var i = 0; i < array.length; ++i){
                        if (beginFound)
                         {
                             if (array[i] !== 10)
                             {
                                 result+= (String.fromCharCode(array[i]));
                             } else {
                                 serialOutput.text = result;
                                 break;
                             }
                         }
                        if (array[i] === 36)
                        {
                           beginFound = true;
                        }
                     }
                     // JSON parser
                     try {
                         var JsonObject= JSON.parse(result);
                         jsonLength.text =   "Serial Bytes: " + result.length;

                         gps.longitude       = JsonObject.gps.lat;
                         gps.latitude        = JsonObject.gps.lon;
                         gps.fix             = JsonObject.gps.fix;
                         gps.sats            = JsonObject.gps.sats;
                         gps.course          = JsonObject.gps.course;
                         gps.speed           = JsonObject.gps.speed;
                         gps.hdop            = JsonObject.gps.hdop;

                         motor.rpm           = JsonObject.Motor.RPM;
                         motor.voltage       = JsonObject.Motor.Bat;
                         motor.current       = JsonObject.Motor.I;
                         motor.temp          = JsonObject.Motor.T_Motor;
                         motor.driveReady    = JsonObject.Motor.Ready;
                         motor.driveEnabled  = JsonObject.Motor.Enable;
                         motor.killSwitch    = JsonObject.Motor.Kill;

                         mppt1.voltageIn     = JsonObject.MPPT.Vin[0];
                         mppt2.voltageIn     = JsonObject.MPPT.Vin[1];
                         mppt3.voltageIn     = JsonObject.MPPT.Vin[2];
                         mppt4.voltageIn     = JsonObject.MPPT.Vin[3];

                         mppt1.currentIn     = JsonObject.MPPT.I[0];
                         mppt2.currentIn     = JsonObject.MPPT.I[1];
                         mppt3.currentIn     = JsonObject.MPPT.I[2];
                         mppt4.currentIn     = JsonObject.MPPT.I[3];

                         mppt1.bvlr          = JsonObject.MPPT.BVLR[0];
                         mppt2.bvlr          = JsonObject.MPPT.BVLR[1];
                         mppt3.bvlr          = JsonObject.MPPT.BVLR[2];
                         mppt4.bvlr          = JsonObject.MPPT.BVLR[3];

                         mppt1.ovt           = JsonObject.MPPT.OVT[0];
                         mppt2.ovt           = JsonObject.MPPT.OVT[1];
                         mppt3.ovt           = JsonObject.MPPT.OVT[2];
                         mppt4.ovt           = JsonObject.MPPT.OVT[3];

                         mppt1.noc           = JsonObject.MPPT.NOC[0];
                         mppt2.noc           = JsonObject.MPPT.NOC[1];
                         mppt3.noc           = JsonObject.MPPT.NOC[2];
                         mppt4.noc           = JsonObject.MPPT.NOC[3];

                         mppt1.undv          = JsonObject.MPPT.UNDV[0];
                         mppt2.undv          = JsonObject.MPPT.UNDV[1];
                         mppt3.undv          = JsonObject.MPPT.UNDV[2];
                         mppt4.undv          = JsonObject.MPPT.UNDV[3];

                         battery.packVoltage     = JsonObject.bms.PackVol;
                         battery.packCurrent     = JsonObject.bms.I;
                         battery.packAmphours    = JsonObject.bms.AmpHr;
                         battery.packHighTemp    = JsonObject.bms.Thigh;
                         //battery.packAvgTemp     = JsonObject.bms.Tav;       // REMOVE SPACE IN GATEWAY
                         battery.packSOC         = JsonObject.bms.SOC
                         battery.packHealth      = 0;                        // MISSING
                         battery.highVoltage     = JsonObject.bms.Vhigh;
                         battery.avgVoltage      = JsonObject.bms.Vav;
                         battery.lowVoltage      = JsonObject.bms.Vlow;

                         battery.discharge       = JsonObject.bms.flags[0];
                         battery.charge          = JsonObject.bms.flags[1];
                         battery.isCharging      = JsonObject.bms.flags[2];

                         batteryBarSet.values = JsonObject.bms.cells;

                         network.canbus = true;

                     } catch(e) {
                         network.canbus = false;
                         network.errors++;
                         jsonLength.text =   "Serial Bytes: " + array.length;
                         jsonMessages.text = "Messages: " + network.messages;
                         jsonErrors.text =   "Errors: " + network.errors;
                         console.info(e); // error in the above string (in this case, yes)!
                         console.info(result);
                         //console.info("Msg: " + gps.messages + ". Errors: " + gps.errors);
                     }
                 }
             }
         }

         Timer {
             id: timer1
             interval: jsonInterval.value
             running: false
             repeat: true
             onTriggered: { readCAN(); }
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

        SpinBox {
            id: batterySet
            x: 200
            y: 10
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
            x: 200
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

        Process {
            id: process
            onReadyRead: brightnessSlider.value = parseInt(readAll());
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
