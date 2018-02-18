import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Item {
    id: dashboard
    height: parent.height
    width: parent.width

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

    CircularGauge {
        id: speedometer
        value: gps.speed
        maximumValue: 50
        width: 250
        height: 250
        x: 10
        y: 10
        style: DashboardGaugeStyle {}
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
