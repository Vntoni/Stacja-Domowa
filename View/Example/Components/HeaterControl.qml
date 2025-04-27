import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    width: 200
    height: 200
    color: "#222"
    radius: 10
    border.color: "white"
    border.width: 1


    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10


        Label {
            text: "Ogrzewanie"
            font.pixelSize: 18
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter

        }
        Button {
            text: "Włącz"
            font.pixelSize: 16
            Layout.fillWidth: true
            onClicked: console.log("Ogrzewanie ON")
            }

        Button {
            text: "Wyłącz"
            font.pixelSize: 16
            Layout.fillWidth: true
            onClicked: console.log("Ogrzewanie OFF")
            }
        }
    }