import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "components"

ApplicationWindow {
    visible: true
    width: 800
    height: 480
    title: "Domowy Panel Sterowania"
    color: "#121212"

    ColumnLayout {
        anchors.fill: parent

        // GÓRA: Statusy
        Rectangle {
            Layout.preferredHeight: 200
            color: "#2E2E2E"
            width: parent.width

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 40

                Text {
                    text: "Temperatura: 22°C"
                    color: "white"
                    font.pixelSize: 24
                }

                Text {
                    text: "Wilgotność: 45%"
                    color: "white"
                    font.pixelSize: 24
                }

                Text {
                    text: "Tryb: AUTO"
                    color: "white"
                    font.pixelSize: 24
                }
            }
        }

        // DÓŁ: Sterowanie
        Rectangle {
            Layout.fillHeight: true
            color: "#1C1C1C"
            width: parent.width

            GridLayout {
                anchors.fill: parent
                anchors.margins: 20
                columns: 3
                rowSpacing: 20
                columnSpacing: 20

                Accontrol {}
                WaterHeaterControl {}
                HeaterControl {}
            }
        }
    }
}
