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
        id: mppt
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
                    id: chartView
                    title: "Power balance"
                    height: 200
                    x: 0
                    y: 330
                    width: parent.width
                    //backgroundColor: "transparent"
                    antialiasing: true
                    legend.visible: false

                    ValueAxis {
                        id: valueAxisX
                        max: 5
                        visible: false
                    }

                    ValueAxis {
                        id: valueAxisY
                        min: 30
                        max: 100
                        visible: true
                    }
                   SplineSeries {
                        id: speedGraph
                        axisX: valueAxisX
                        axisY: valueAxisY
                        color: "#C6002A"
                        width: 2
                        XYPoint { x: 0; y: 50 }
                        XYPoint { x: 1.1; y: 52 }
                        XYPoint { x: 1.9; y: 66 }
                        XYPoint { x: 2.1; y: 73 }
                        XYPoint { x: 2.9; y: 81 }
                        XYPoint { x: 3.4; y: 74 }
                        XYPoint { x: 4.1; y: 71 }
                        XYPoint { x: 5; y: 79 }
                    }
                    SplineSeries {
                        id: speedGraph1
                        axisX: valueAxisX
                        axisY: valueAxisY
                        color: "#006C2A"
                        width: 2
                        XYPoint { x: 0; y: 63 }
                        XYPoint { x: 1.1; y: 65 }
                        XYPoint { x: 1.9; y: 62 }
                        XYPoint { x: 2.1; y: 57 }
                        XYPoint { x: 2.9; y: 59 }
                        XYPoint { x: 3.4; y: 65 }
                        XYPoint { x: 4.1; y: 65 }
                        XYPoint { x: 5; y: 66 }
                    }


                }

                ChartView {
                    title: "Battery Cell-Voltage"
                    height: 300
                    x: 0
                    y: 530
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

                Text {
                    x: 430
                    y: 380
                    text: "+67 W"
                    color: "#006C2A"
                    font.weight: Font.Black
                    font.pixelSize: 30
                }

                MpptStatus {
                    y: 0
                    name: "MPPT #1"
                    output: "167 W"
                    status: "Tracking"
                    indicator: "green"
                }

                MpptStatus {
                    y: 80
                    name: "MPPT #2"
                    output: "189 W"
                    status: "Not Charging"
                }
                MpptStatus {
                    y: 160
                    name: "MPPT #3"
                    output: "171 W"
                    status: "Undervoltage"
                }
                MpptStatus {
                    y: 240
                    name: "MPPT #4"
                    output: "123 W"
                    status: "No Battery"
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
            x: 70
            y: 27
            width: 50
            color: "#a54208"
            text: qsTr("NO FIX")
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: modeIndicator
            x: 120
            y: 7
            color: "#000000"
            text: "" //qsTr("3G")
            font.pixelSize: 11
        }

        Text {
            id: carrier
            x: 160
            y: 11
            width: 90
            height: 14
            color: "#000000"
            text: network.carrier
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

            Rectangle {
                id: inputTextField
                y: Qt.inputMethod.visible ? parent.height - inputPanel.height - inputTextField.height : parent.height
                anchors.left: parent.left
                anchors.right: parent.right
                z: 100
                height: 30
                color: "white"

                TextField {
                    focus: true
                    width: parent.width
                }

            }
        }

}


