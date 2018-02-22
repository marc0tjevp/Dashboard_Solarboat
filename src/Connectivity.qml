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
            console.info("[INFO] Connecting to: " + comboBox13.currentText);
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
        height: 170
        font.pixelSize: 10
        readOnly: true
        wrapMode: TextArea.WrapAnywhere
    }
    Timer {
        id: timer1
        interval: jsonInterval.value
        running: false
        repeat: true
        onTriggered: {
            if (serial.isOpen()){

                var array = serial.readBytes();
                var result = "";
                var beginFound = false;
                if (array.length > 600){
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

                        //motor.rpm           = JsonObject.motor.rpm;
                        //motor.current       = JsonObject.motor.i;

                        gps.longitude       = JsonObject.gps.alt;
                        gps.latitude        = JsonObject.gps.lon;
                        gps.fix             = JsonObject.gps.fix;
                        gps.sats            = JsonObject.gps.sats;
                        gps.course          = JsonObject.gps.course;
                        gps.speed           = JsonObject.gps.speed;
                        batteryBarSet.values = JsonObject.battery.cells;

                    } catch(e) {
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
    }

    Text {
        id: jsonMessages
        x: 10
        y: 210
        font.pixelSize: 12
    }
    Text {
        id: jsonErrors
        x: 120
        y: 210
        font.pixelSize: 12
    }
    Text {
        id: jsonLength
        x: 200
        y: 210
        font.pixelSize: 12
    }
    SpinBox {
        id: jsonInterval
        x: 300
        y: 195
        enabled: true
        stepSize: 50
        scale: 0.8
        value: 500
        to: 500
        width: 150
    }
}
