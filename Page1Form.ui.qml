import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: item1
    width: 800
    clip: true

    TabBar {
        id: tabBar
        width: 550
        anchors.left: parent.left
        anchors.leftMargin: 0
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        TabButton {
            text: qsTr("Dashboard")
        }
        TabButton {
            text: qsTr("Control")
        }
        TabButton {
            text: qsTr("Connectivity")
        }
        TabButton {
            text: qsTr("Energy")
        }
    }

    StackLayout {
        width: 550
        height: 440
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 40
        currentIndex: bar.currentIndex
        Item {
            id: dashboardTab
        }
        Item {
            id: controlTab
        }
        Item {
            id: connectivityTab
        }
        Item {
            id: energyTab
        }
    }

    ToolBar {
        id: toolBar
        width: 250
        anchors.right: parent.right
        anchors.rightMargin: 0
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignRight | Qt.AlignTop
    }
}
