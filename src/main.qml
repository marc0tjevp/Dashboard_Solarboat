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
    color: "#CCCCCC"
    title: qsTr("Dashboard")

    ValueSource {
        id: valueSource
    }

    Item {
        id: gps
        property bool   tracking:       true
        property bool   fix:            false
        property real   longitude:      51.589163
        property real   latitude:       4.788127
        property real   speed:          valueSource.kph * 0.3
        property real   sats:           0
        property real   course:         valueSource.kph
        property real   hdop:           0
    }
    Item {
        id: network
        property real   messages:       0
        property real   errors:         0
        property bool   canbus:         false
        property bool   internet:       true
    }

    Item {
        id: motor
        property real   rpm:            valueSource.rpm * 500
        property real   voltage:        48
        property real   current:        valueSource.rpm * 1.5
        property real   power:          Math.round(motor.voltage * motor.current)
        property real   temp:           39
        property bool   driveReady:     true
        property bool   killSwitch:     false
    }
    Item {
        id: mppt1
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property bool   bnc:            false
        property bool   undv:           false
        property bool   ovt:            false
        property bool   noc:            false
    }
    Item {
        id: mppt2
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property bool   bnc:            false
        property bool   undv:           false
        property bool   ovt:            false
        property bool   noc:            false
    }
    Item {
        id: mppt3
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property bool   bnc:            false
        property bool   undv:           false
        property bool   ovt:            false
        property bool   noc:            false
    }
    Item {
        id: mppt4
        property real   currentIn:      0
        property real   voltageIn:      0
        property real   temp:           0
        property bool   bnc:            false
        property bool   undv:           false
        property bool   ovt:            false
        property bool   noc:            false
    }
    Item {
        id: battery
        property real   packVoltage:    0
        property real   packCurrent:    0
        property real   packAmphours:   0
        property real   packHighTemp:   0
        property real   packSOC:        0
        property real   packHealth:     0
        property real   highVoltage:    0
        property real   avgVoltage:     0
        property real   lowVoltage:     0
        property real   cellVoltages:   0
        property real   bmsStatus:      0
        property real   relaisStatus:   0
        property real   errorCodes:     0
    }

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered:
        {


            gps.longitude += 0.00005
        }
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
            SystemControl {}
        }

        Item {
            id: detailsTab
            Flickable {
                flickableDirection: Flickable.VerticalFlick
                width: parent.width;
                height: parent.height
                contentWidth: parent.width;
                contentHeight: 1000

                ScrollBar.vertical: ScrollBar { width: 5 }

                ChartView {
                    title: "Battery Cell-Voltage [V]"
                    height: 300
                    x: 0
                    y: 320
                    width: parent.width
                    antialiasing: true
                    legend.visible: false

                    ValueAxis {
                        id: batteryAxisY
                        min: 2.4
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
                    indicator: "none"
                    //status: "Not Connected"
                    voltageInput: Math.round(mppt1.voltageIn * 100)/100
                    currentInput: Math.round(mppt1.currentIn * 100)/100
                    noCharge: "none"
                    batteryNotConnected: "none"
                    overVoltage: "none"
                    underVoltage: "none"
                }

                MpptStatus {
                    y: 80
                    name: "MPPT #2"
                    voltageInput: Math.round(mppt2.voltageIn * 100)/100
                    currentInput: Math.round(mppt2.currentIn * 100)/100
                }
                MpptStatus {
                    y: 160
                    name: "MPPT #3"
                    voltageInput: Math.round(mppt3.voltageIn * 100)/100
                    currentInput: Math.round(mppt3.currentIn * 100)/100
                }
                MpptStatus {
                    y: 240
                    name: "MPPT #4"
                    voltageInput: Math.round(mppt4.voltageIn * 100)/100
                    currentInput: Math.round(mppt4.currentIn * 100)/100
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
                ScrollBar.vertical: ScrollBar { width: 5 }

                Connectivity {}
            }

        }

        Item {
            id: chatTabs

            ChatContainer {}
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
            text: qsTr("Settings")
        }
        TabButton {
            height: 40
            width: 100
            text: qsTr("Details")
        }
        TabButton {
            height: 40
            text: qsTr("Connectivity")
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
        PluginParameter { name: "osm.mapping.host"; value: "https://tile.openstreetmap.org/" }
//        PluginParameter { name: "osm.geocoding.host"; value: "https://nominatim.openstreetmap.org" }
//        PluginParameter { name: "osm.routing.host"; value: "https://router.project-osrm.org/viaroute" }
//        PluginParameter { name: "osm.places.host"; value: "https://nominatim.openstreetmap.org/search" }
        PluginParameter { name: "osm.mapping.highdpi_tiles"; value: false }
    }

    Map {
        id: map
        x: 550
        y: 40
        height: parent.height + 200
        antialiasing: false
        tilt: 0
        bearing: gps.tracking ? gps.course : 0
        copyrightsVisible: false
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        plugin: mapPlugin
        center: QtPositioning.coordinate(51.589163, 4.788127)
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
                antialiasing: true
                center: QtPositioning.coordinate(gps.longitude, gps.latitude)
                onCenterChanged: {
                    if (gps.tracking) {
                        map.center = QtPositioning.coordinate(gps.longitude, gps.latitude);
                    }
                }

                radius: 1.0
                color: 'red'
                opacity: 0.8
                border.width: 1
            }
        MapQuickItem {
          id: marker
          coordinate: QtPositioning.coordinate(gps.longitude, gps.latitude)
          anchorPoint.x: image.width * 0.5
          anchorPoint.y: image.height * 0.5
          rotation: gps.tracking ? 0 : gps.course

          sourceItem: Image {
             id: image
             width: 20
             fillMode: Image.PreserveAspectFit
             source: "/img/boat.png"
          }

        }
        MapPolyline {
                line.width: 5
                opacity: 0.5
                line.color: 'red'
                path: [
                    { latitude: 51.57024, longitude: 4.74425 },
                    { latitude: 51.57   , longitude: 4.74432 },
                    { latitude: 51.57006, longitude: 4.74493 },
                    { latitude: 51.57035, longitude: 4.74686 }
                ]
            }
    }

    Image {
        id: fullMap
        source: "/img/enlarge.png"
        fillMode: Image.PreserveAspectFit
        x: 751
        y: 432
        width: 50
        height: 35
        opacity: 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 0
        MouseArea {
            anchors.fill: parent
            onClicked:
                {
                    if(map.state == "small")
                    {
                        map.state = "full"
                    } else {
                        map.state = "small"
                    }
                }
            }
        }

    Image {
        id: recenterMap
        source: "img/Maps-Center-Direction-icon.png"
        fillMode: Image.PreserveAspectFit
        height: 35
        width: 50
        x: 750
        y: 50
        opacity: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (gps.tracking)
                {
                    gps.tracking = false;
                    recenterMap.opacity = 0.5;
                } else {
                    gps.tracking = true;
                    recenterMap.opacity = 1;
                    map.center = QtPositioning.coordinate(gps.longitude, gps.latitude);
                }
            }
        }
    }

    InfoBar {
        id: infoBar
        x: 550
        y: 0
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


