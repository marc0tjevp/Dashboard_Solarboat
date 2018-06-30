function func() {
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

//                mppt1.temp          = JsonObject.MPPT.Temp[0];
//                mppt2.temp          = JsonObject.MPPT.Temp[1];
//                mppt3.temp          = JsonObject.MPPT.Temp[2];
//                mppt4.temp          = JsonObject.MPPT.Temp[3];

                motor.rpm           = JsonObject.Motor.RPM;
                motor.voltage       = JsonObject.Motor.Bat;
                motor.current       = JsonObject.Motor.I;
                motor.temp          = JsonObject.Motor.T_Motor;
                motor.tempPCB       = JsonObject.Motor.T_PCB;
                motor.direction     = JsonObject.Motor.Dir;
                motor.driveReady    = JsonObject.Motor.Ready;
                motor.driveEnabled  = JsonObject.Motor.Enable;
                motor.killSwitch    = JsonObject.Motor.Kill;
                motor.setRPM        = JsonObject.Motor.Hn;
                motor.setCurrent    = JsonObject.Motor.Hi;
                motor.state         = JsonObject.Motor.St;
                motor.failSafe      = JsonObject.Motor.Fault[0];
                motor.timeout       = JsonObject.Motor.Fault[1];
                motor.overVoltage   = JsonObject.Motor.Fault[2];
                motor.underVoltage  = JsonObject.Motor.Fault[3];

                battery.packVoltage     = JsonObject.bms.PackVol;
                battery.packCurrent     = JsonObject.bms.I;
                battery.packAmphours    = JsonObject.bms.AmpHr;
                battery.packHighTemp    = JsonObject.bms.Thigh;
                battery.packSOC         = JsonObject.bms.SOC
                battery.highVoltage     = JsonObject.bms.Vhigh;
                battery.avgVoltage      = JsonObject.bms.Vav;
                battery.lowVoltage      = JsonObject.bms.Vlow;

                battery.discharge       = JsonObject.bms.flags[0];
                battery.charge          = JsonObject.bms.flags[1];
                battery.isCharging      = JsonObject.bms.flags[2];

                informationTab.batteryBarSet = JsonObject.bms.cells;

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

                network.canbus = true;

                var xhr = new XMLHttpRequest();
                xhr.open("POST", 'http://localhost:8888', true);
                xhr.send(result + "\n");

//                var buffer = "sendJson '" + result + "'";
//                telegrafWorker.start(buffer);
//                console.debug(buffer);



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
