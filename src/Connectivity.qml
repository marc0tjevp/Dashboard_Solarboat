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
//import QtWebEngine 1.0

Item {
    width: parent.width
    height: parent.height

   Item {
        id: mobile
        property real   token: 0
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
            width: 390
            x: 10
            y: 5
            model: comboModel.comboList
            editable: false
        }
        Button {
            id: connectSerial
            text: "Connect"
            x: 410
            y: 5
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
                        serial.paramSet('dtr', '0');
                        serial.paramSet('rts', '0');
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
            y: 45
            width: parent.width -20
            height: 120
            font.pixelSize: 12
            readOnly: true
            wrapMode: TextArea.WrapAnywhere
            placeholderText: "[1] Select the correct device in the dropdown menu.\n[2] Press Connect.\n\nIf the correct device is not shown: Check /dev/. Restart program. \n\nThis system is designed for Gateway Firmware 1.3."
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
                    if (array.length > 0){
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

                            //motor.rpm           = JsonObject.motor.rpm;

                            gps.longitude       = JsonObject.gps.alt;
                            gps.latitude        = JsonObject.gps.lon;
                            gps.fix             = JsonObject.gps.fix;
                            gps.sats            = JsonObject.gps.sats;
                            gps.course          = JsonObject.gps.course;
                            gps.speed           = JsonObject.gps.speed;
                            batteryBarSet.values = JsonObject.battery.cells;

                            mppt1.voltageIn     = JsonObject.MPPT.MPPT_VoltageIn[0];
                            mppt2.voltageIn     = JsonObject.MPPT.MPPT_VoltageIn[1];
                            mppt3.voltageIn     = JsonObject.MPPT.MPPT_VoltageIn[2];
                            mppt4.voltageIn     = JsonObject.MPPT.MPPT_VoltageIn[3];


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
            y: 170
            font.pixelSize: 12
        }
        Text {
            id: jsonErrors
            x: 120
            y: 170
            font.pixelSize: 12
        }
        Text {
            id: jsonLength
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
            to: 500
            width: 150
        }
   }

   Rectangle {
       x: 10
       y: 220
       width: parent.width - 20
       height: 200
       radius: 5
       color: "white"

       Button {
           x: 400
           y: 10
           text: "Get XML"
           onPressed: {
               getXML("http://192.168.8.1/api/monitoring/traffic-statistics");

               function getXML(url) {
                   var client = new XMLHttpRequest();
                   client.onreadystatechange = function() {
                       if (client.readyState === XMLHttpRequest.DONE) {
                           //console.info(client.responseText);
                           xmlOutput.text = client.responseText;
                       }
                   }

                   client.open("GET", url);
                   client.send();
               }
           }
       }
       Button {
           x: 400
           y: 110
           text: "Get XML"
           onPressed: {
               getXML("http://192.168.8.1/api/monitoring/status");

               function getXML(url) {
                   var client = new XMLHttpRequest();
                   client.onreadystatechange = function() {
                       if (client.readyState === XMLHttpRequest.DONE) {
                           //console.info(client.responseText);
                           xmlOutput.text = client.responseText;
                       }
                   }

                   client.open("GET", url);
                   client.send();
               }
           }
       }
       Button {
           id: mobileSwitch
           x: 400
           y: 60
           text: "Switch"
           checkable: true
           onCheckedChanged: {
               //getToken("http://hi.link/api/webserver/token");
               //getToken("http://192.168.8.1/api/monitoring/traffic-statistics");
               getToken("test.xml");


               function getToken(url) {
                   var request = new XMLHttpRequest();
                   request.open("GET", url);
                   request.send();
                   request.onreadystatechange = function() {
                       if (request.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                           console.info(request.getAllResponseHeaders());

                       } else if (request.readyState === XMLHttpRequest.DONE) {
                           xmlOutput.text = request.responseText;
                           console.debug(JSON.stringify(request));
                           mobile.token = request.responseXML.documentElement.childNodes[1].firstChild.nodeValue;
                           console.debug(mobile.token);
                       }
                   }
               }

               var xhr = new XMLHttpRequest();
               xhr.open("POST", 'http://192.168.8.1/api/dialup/mobile-dataswitch');

               //Send the proper header information along with the request
               xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
               xhr.setRequestHeader("Referer", "http://192.168.8.1/html/home.html");
               xhr.setRequestHeader("__RequestVerificationToken", mobile.token);
               xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");

               xhr.onreadystatechange = function() {//Call a function when the state changes.
                   if(xhr.readyState === XMLHttpRequest.DONE && xhr.status == 200) {
                       // Request finished. Do processing here.
                   }
               }
               if (mobileSwitch.checked)
               {
                   xhr.send('<?xml version="1.0" encoding="UTF-8"?><request><dataswitch>1</dataswitch></request>');
               } else {
                   xhr.send('<?xml version="1.0" encoding="UTF-8"?><request><dataswitch>0</dataswitch></request>');
               }


           }
       }
       Text {
           id: xmlOutput
           x: 10
           y: 10
           font.pixelSize: 12
       }
   }
   /*WebEngineView {
       x: 0
       y: 480
       height: 400
       width: parent.width
       url: "http://192.168.8.1"
   }*/
}
