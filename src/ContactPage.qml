import QtQuick 2.7
import QtQuick.Controls 2.2
import io.qt.examples.chattutorial 1.0

Page {
    id: root

    ListView {
        id: listView
        anchors.fill: parent
        topMargin: 48
        leftMargin: 48
        bottomMargin: 48
        rightMargin: 48
        spacing: 20
        model: SqlContactModel {}
        delegate: ItemDelegate {
            text: model.display
            width: listView.width - listView.leftMargin - listView.rightMargin
            height: avatar.implicitHeight
            leftPadding: avatar.implicitWidth + 32
            onClicked: root.StackView.view.push("qrc:/ConversationPage.qml", { inConversationWith: model.display })

            Image {
                id: avatar
                source: "qrc:///img/" + model.display.replace(" ", "_") + ".png"
            }
        }
    }
}
