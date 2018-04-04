import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    id: chatContainerBox
    anchors.fill: parent

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: ContactPage {}
    }
}
