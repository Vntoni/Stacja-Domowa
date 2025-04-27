import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: acPopup
    // zamiast aliasu – zwykła property
    property string room: ""

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    width: 300; height: 260
    background: Rectangle { color: "#333"; radius: 10 }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Wyświetlamy nazwę pokoju:
        Text {
            text: qsTr("Klimatyzacja %1").arg(acPopup.room);
            font.pixelSize: 20
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        // Suwak temperatury
        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignHCenter

            Text { text: qsTr("Temp:"); color: "white" }

            Slider {
                id: tempSlider
                from: 16; to: 30; stepSize: 0.5
                onMoved: backend.set_temperature(acPopup.room, value)
            }

            Text {
                text: tempSlider.value.toFixed(1) + "°C"
                color: "white"
            }
        }

        // Tryb pracy
        ComboBox {
            id: modeBox
            model: [ "cool", "heat", "dry", "fan", "auto" ]
            currentIndex: 0
            onCurrentTextChanged: backend.set_mode(acPopup.room, currentText)
        }

        // Tryb ekonomiczny
        CheckBox {
            text: qsTr("Economy mode")
            onCheckedChanged: backend.set_economy_mode(acPopup.room, checked)
            contentItem: Text { text: control.text; color: control.checked ? "#17a81a" : "white" }
        }

        Button {
            text: qsTr("Zamknij")
            Layout.alignment: Qt.AlignHCenter
            onClicked: acPopup.close()
        }
    }
}
