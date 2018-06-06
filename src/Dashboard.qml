import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.2
import QtQuick.Extras 1.4
import QtCharts 2.2
import QtGraphicalEffects 1.0
import QtLocation 5.9
import QtPositioning 5.8
import QtQuick.Layouts 1.3

Item {
    id: dashboard

    height: parent.height
    width: parent.width

    Rectangle {
        x: 10
        y: 10
        height: 120
        width: 200
        radius: 5

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -10
            anchors.right: parent.right
            anchors.rightMargin: 80
            text: (gps.speed | 0)
            font.pixelSize: 90
            font.family: "Arial"
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 115
            color: "#444444"
            text: "," + (gps.speed % 1 * 10 | 0)
            font.pixelSize: 50
            font.family: "Arial"
        }
        Text {
            x: 10
            y: 10
            text: "Km/h"
        }

        Text {
            id: revsMotor
            text: (motor.rpm | 0) + " RPM"
            x: 10
            y: 10
            font.pixelSize: 18
            anchors.right: parent.right
            anchors.rightMargin: 10
            horizontalAlignment: Text.AlignRight
        }
    }

    Rectangle {
        x: 220
        y: 10
        height: 120
        width: 320
        radius: 5

        Text {
            id: timeLeft
            text: "Time Left: 00:00"
        }
        Text {
            id: batteryCurrent
            text: "Time Left: 00:00"
        }


    }

    Rectangle {
        x: 10
        y: 140
        height: 250
        width: 530
        radius: 5


    }

    ChartView {
        legend.visible: false
        antialiasing: false
        margins.top: 0
        margins.left: 0
        margins.right: 0
        backgroundColor: "#00000000"
        animationDuration: 100
        animationOptions: ChartView.SeriesAnimations
        y: 375
        height: 100
        width: 550

        ValueAxis {
            id: axisY
            visible: false
        }

        ValueAxis {
            id: axisX
            visible: false
        }

        HorizontalPercentBarSeries {
            axisX: axisX
            axisY: axisY
            BarSet { id: motorBar; label: "Motor"; values: [motor.power + 1]; color: "#278e89" }
            BarSet { id: solarBar; label: "Solar"; values: [mppt.totalPower + 1]; color: "#54c44a" }
        }
    }
    Text {
        text: Math.round(motor.power) + "W \nMotor"
        x: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 13
        font.bold: true
        font.pixelSize: 10
        color: "white"
    }
    Text {
        text: mppt.totalPower + "W \nSolar"
        anchors.right: parent.right
        anchors.rightMargin: 300
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 14
        horizontalAlignment: Text.AlignRight
        font.bold: true
        font.pixelSize: 10
        color: "white"
    }

    Plugin {
        id: mapPlugin
        name: "osm" // "mapboxgl", "esri", here, osm
        // specify plugin parameters if necessary
        PluginParameter {
            name:"osm.mapping.custom.host"
            value:"http://tiles.openseamap.org/seamark/"
        }
        PluginParameter {
            name:"osm.mapping.providersrepository.disable"
            value:true
        }
        PluginParameter {
            name: "osm.mapping.highdpi_tiles"
            value: false
        }
    }

    Map {
        id: map
        height: parent.height + 200
        antialiasing: false
        gesture.enabled: false
        bearing: gps.tracking ? gps.course : 0
        copyrightsVisible: false
        anchors.top: parent.top
        anchors.right: parent.right
        plugin: mapPlugin
        center: QtPositioning.coordinate(gps.longitude, gps.latitude)
        zoomLevel: 17
        activeMapType: map2.supportedMapTypes[0]
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
    }


    Map {
        id: map2
        height: map.height
        width: map.width
        antialiasing: false
        gesture.enabled: false
        bearing: map.bearing
        copyrightsVisible: false
        anchors.top: parent.top
        anchors.right: parent.right
        plugin: mapPlugin
        center: map.center
        zoomLevel: map.zoomLevel
        activeMapType: map2.supportedMapTypes[6]
        color: "#00000000"
    }

    Text {
        id: mapHDOP
        text: "HDOP: " + gps.hdop + " | Sats: " + gps.sats
        anchors.left: map.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        font.pixelSize: 12
        style: Text.Outline
        styleColor: "white"
    }
    Text {
        id: mapBearing
        text: gps.course + "°"
        anchors.left: map.left
        anchors.leftMargin: 5
        anchors.top: map.top
        anchors.topMargin: 5
        font.pixelSize: 12
        style: Text.Outline
        styleColor: "white"
    }

    Image {
        id: fullMap
        source: "/img/enlarge.png"
        fillMode: Image.PreserveAspectFit
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
                    if(map.state === "small")
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
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        opacity: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (gps.tracking)
                {
                    gps.tracking = false;
                    recenterMap.opacity = 0.5;
                    map.gesture.enabled = true;
                } else {
                    gps.tracking = true;
                    recenterMap.opacity = 1;
                    map.gesture.enabled = false;
                    map.center = QtPositioning.coordinate(gps.longitude, gps.latitude);
                }
            }
        }
    }

    // Map zooming buttons
    Button {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 55
        anchors.left: map.left
        height: 45
        width: 45
        text: "+"
        onPressed: map.zoomLevel = Math.round(map.zoomLevel + 1)
    }
    Button {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: map.left
        height: 45
        width: 45
        text: "-"
        onPressed: map.zoomLevel = Math.round(map.zoomLevel - 1)
    }
}
