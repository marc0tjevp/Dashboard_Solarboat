import QtQuick 2.9
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

ApplicationWindow {
    visible: true
    width: 800
    height: 480
    color: "#DDDDDD"
    title: qsTr("Dashboard")
    id: root

    Item {
        id: gps
        property bool   tracking:       true
        property real   longitude:      53.051307
        property real   latitude:       5.835714
        property real   speed:          0
        property real   fix:            0
        property real   sats:           0
        property real   course:         0
    }
    Item {
        id: network
        property int    mobileSignal:   0
        property string carrier:        "NA"
        property int    messages:       0
        property int    errors:         0
    }

    Item {
        id: motor
        property real   rpm:            0
        property real   current:        0
    }
    Item {
        id: mppt1
        property real   currentIn:      3.26
        property real   voltageIn:      55.12
    }
    Item {
        id: mppt2
        property real   currentIn:      3.26
        property real   voltageIn:      55.12
    }
    Item {
        id: mppt3
        property real   currentIn:      3.26
        property real   voltageIn:      55.12
    }
    Item {
        id: mppt4
        property real   currentIn:      3.26
        property real   voltageIn:      55.12
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

                Dashboard {}
        }


        Item {
            id: controlTab

            Flickable {
                id: flickable
                flickableDirection: Flickable.VerticalFlick
                width: parent.width;
                height: parent.height
                contentWidth: parent.width;
                contentHeight: 1000;

                //Control {}
                SystemControl {}
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

                Connectivity {}
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

                ScrollBar.vertical: ScrollBar { width: 5 }

                ChartView {
                    title: "Battery Cell-Voltage"
                    height: 300
                    x: 0
                    y: 330
                    width: parent.width
                    antialiasing: true
                    legend.visible: false

                    ValueAxis {
                        id: batteryAxisY
                        min: 2.5
                        max: 4.2
                        visible: true
                    }
                    ValueAxis {
                        id: batteryNorm
                        min: 0
                        max: 1
                        visible: false
                    }

                    StackedBarSeries {
                        id: mySeries
                        axisY: batteryAxisY
                        axisX: BarCategoryAxis { categories: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" ] }
                        BarSet { id: batteryBarSet; label: "Cell"; values: [3.1, 3.1, 3.3, 3.8, 3.2, 3.0, 4.0, 4.1, 4.0, 3.2, 3.2, 4.0] }
                    }
                    LineSeries {
                        axisX : batteryNorm
                        XYPoint { x: 0; y: 3.65 }
                        XYPoint { x: 1; y: 3.65 }
                    }
                }
                Rectangle {
                    y: 600
                    x: 9
                    height: 100
                    width: 532

                    Text {
                        id: batterySOC
                        x: 5
                        text: qsTr("State of Charge: 83%")
                    }
                }

                MpptStatus {
                    y: 0
                    name: "MPPT #1"
                    output: Math.round(mppt1.voltageIn * mppt1.currentIn) + " W"
                    status: "Tracking"
                    indicator: "green"
                    voltageInput: Math.round(mppt1.voltageIn * 100)/100 + " V"
                }

                MpptStatus {
                    y: 80
                    name: "MPPT #2"
                    output: "189 W"
                    status: "Not Charging"
                    voltageInput: mppt2.voltageIn + " V"
                }
                MpptStatus {
                    y: 160
                    name: "MPPT #3"
                    output: "171 W"
                    status: "Undervoltage"
                    voltageInput: mppt3.voltageIn + " V"
                }
                MpptStatus {
                    y: 240
                    name: "MPPT #4"
                    output: "123 W"
                    status: "No Battery"
                    voltageInput: mppt4.voltageIn + " V"
                }
            }
        }

        Item {
            id: chatTabs

            Rectangle {
                id: chatContainer
                x: 0
                y: 0
                width: parent.width
                color: "White"
                height: parent.height

                Flickable {
                    id: chatMessagesContainer
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.bottom: chatTextField.top
                    width: parent.width
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: 1000

                    Rectangle {
                        height: 100
                        width: 100
                        color: "yellow"
                    }

                }

                TextField {
                    id: chatTextField
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.right: chatSendButton.left
                    anchors.rightMargin: 5
                    onFocusChanged: {
                        if (chatTextField.focus == true) {
                            chatContainer.height = 190;
                        } else {
                            chatContainer.height = 440;
                        }
                    }
                }
                Button {
                    id: chatSendButton
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    text: "Send"
                    width: 60
                    onPressed: {
                        chatTextField.text = "";
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
            width: 100
            text: qsTr("Energy")
        }
        TabButton {
            height: 40
            width: 60
            text: qsTr("Chat")
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
        height: parent.height + 200
        antialiasing: false
        tilt: 0
        bearing: gps.course
        copyrightsVisible: false
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        plugin: mapPlugin
        center: QtPositioning.coordinate(53.051307, 5.835714)
        zoomLevel: 19
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
        MapCircle {
                id: boatCircle
                center: QtPositioning.coordinate(gps.longitude, gps.latitude)
                onCenterChanged: {
                    if (gps.tracking) {
                        map.center = QtPositioning.coordinate(gps.longitude, gps.latitude);
                    }
                }

                radius: 5.0
                color: 'red'
                opacity: 0.8
                border.width: 1
            }
        MapPolyline {
                line.width: 5
                opacity: 0.5
                line.color: 'blue'
                path: [
                    { latitude: 51.57024, longitude: 4.74425 },
                    { latitude: 51.57   , longitude: 4.74432 },
                    { latitude: 51.57006, longitude: 4.74493 },
                    { latitude: 51.57035, longitude: 4.74686 }
                ]
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
        }
    }
    Button {
        id: recenterMap
        x: 751
        y: 45
        width: 50
        height: 50
        text: qsTr("[+]")
        opacity: 0.8
        checkable: true
        checked: gps.tracking
        onCheckedChanged:
        {
            gps.tracking = recenterMap.checked;
            if (recenterMap.checked) {
                map.center = QtPositioning.coordinate(gps.longitude, gps.latitude);
            }
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
            x: 50
            y: 27
            width: 50
            color: "#a54208"
            text: qsTr("NO FIX")
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: modeIndicator
            x: 110
            y: 7
            color: "#000000"
            text: "" //qsTr("3G")
            font.pixelSize: 11
        }

        Text {
            id: clock
            color: "#000000"
            text: Qt.formatTime(new Date(), "hh:mm:ss")
            anchors.top: parent.top
            anchors.topMargin: 4
            font.bold: true
            anchors.right: parent.right
            anchors.rightMargin: 10
            font.pixelSize: 24

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
            width: 20
            height: 20
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.right: parent.right
            anchors.rightMargin: 160
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
            width: 30
            height: 24
            anchors.right: parent.right
            anchors.rightMargin: 110
            anchors.top: parent.top
            anchors.topMargin: 8
            state: network.mobileSignal
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


