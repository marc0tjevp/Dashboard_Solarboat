import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Item {
    id: dashboard

    height: parent.height
    width: parent.width

    FontLoader { id: handwriting; source: "qrc:///font/handwriting-draft_free-version.ttf" }
    FontLoader { id: lcd; source: "qrc:///font/digital-7.ttf" }

    Text {
        id: txt_RPM
        x: 0
        y: 300
        text: motor.rpm
    }
    Text {
        id: txt_Current
        x: 100
        y: 300
        text: motor.current
    }

    Text {
        x: 10
        y: 10
        text: gps.speed + " km/h"
        font { family: lcd.name; pixelSize: 100;}
    }

    Timer {
        property int timeline: 0 // Start of the timeline
        id: speedoTimer
        interval: 50
        running: false
        repeat: true
        onTriggered: {
            timeline++;
            speedGraph.append(timeline, speedometer.value);

            if(timeline + 100 > valueAxisX.max){
                valueAxisX.min = timeline - 900;
                valueAxisX.max = timeline + 100;
            }
            if (timeline > valueAxisX.max){
                speedGraph.remove(0);
            }
        }
    }

    Image {
        id: quitButton
        x: 0
        y: 400
        source: "qrc:///img/quit.png"
        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }
}
