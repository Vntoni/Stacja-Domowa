import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 200
    height: 200

    GroupBox {
        anchors.fill: parent
        title: "Grzanie Wody"
        font.pixelSize: 16

        Column {
            anchors.centerIn: parent
            spacing: 10

            Button {
                text: "Włącz"
                onClicked: console.log("Woda ON")
            }

            Button {
                text: "Wyłącz"
                onClicked: console.log("Woda OFF")
            }
        }
    }
}
