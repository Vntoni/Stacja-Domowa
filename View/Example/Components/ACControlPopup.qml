import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Popup {
    id: acPopup
    property string room: "Jadalnia"
    property string currentMode: "cool" // domyślnie
    property real initialTemperature: 21.0
    property bool initialEconomy: false
    property bool initialPowerful: false
    property bool initialLowNoise: false
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 0.9 }
    }
    width: 400; height: 400
    background: Rectangle { color: "#4f6c7d"; radius: 10; opacity: 0.9}

    Component.onCompleted: {
        acPopup.x = (parent.width - acPopup.width) / 2
        acPopup.y = (parent.height - acPopup.height) / 2
        backend.get_mode_operation(room)
        backend.get_target_temp(room)
        backend.get_economy(room)
        backend.get_powerful(room)
        backend.get_low_noise(room)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Tu wstawiamy nasz Dial
        Item {
            id: dialItem
            width: 150; height: 150
            Layout.alignment: Qt.AlignHCenter

          Dial {
    id: control
    from: 10
    to: 30
    stepSize: 0.5
    snapMode: Dial.SnapAlways

    background: Rectangle {
        x: control.width / 2 - width / 2
        y: control.height / 2 - height / 2
        implicitWidth: 140
        implicitHeight: 140
        width: Math.max(64, Math.min(control.width, control.height))
        height: width
        color: "transparent"
        radius: width / 2
        border.color: control.pressed ? "#d9e8e9" : "#e9f4f5"
        opacity: control.enabled ? 1 : 0.3


    }


    handle: Rectangle {
        id: handleItem
        x: control.background.x + control.background.width / 2 - width / 2
        y: control.background.y + control.background.height / 2 - height / 2
        width: 16
        height: 16
        color: control.pressed ? "#d9e8e9" : "#e9f4f5"
        radius: 8
        antialiasing: true
        opacity: control.enabled ? 1 : 0.3
        transform: [
            Translate {
                y: -Math.min(control.background.width, control.background.height) * 0.4 + handleItem.height / 2
            },
            Rotation {
                angle: control.angle
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]
    }


        // teraz contentItem prawidłowo centr@!
        contentItem: Text {
            text: control.value.toFixed(1) + "°C"
            font.pixelSize: 18; color: "white"
            anchors.centerIn: parent
            // jeśli nadal nieco wisi, dodaj offset:
            anchors.horizontalCenterOffset: 50
            anchors.verticalCenterOffset: 57
        }
    }
        Glow {
        anchors.fill: dialItem
        spread: 0.2
        source: control
        radius: 4
        samples: 32

color: currentMode === "heat" ? "#ff4444"
        : currentMode === "cool" ? "#448aff"
        : currentMode === "dry" ? "#ffcc00"
        : currentMode === "fan" ? "#aaaaaa"
        : "#21be2b" // domyślny kolor

    }
}

        // reszta Twojego layoutu…
        RowLayout {
            spacing: 10; Layout.fillWidth: true
            Label { text: "Tryb:"; color: "white"; font.pixelSize: 14 }
            ComboBox {
                model: ["cool","heat","dry","fan","auto"]
                onCurrentTextChanged: {
                currentMode = currentText
                backend.set_mode_operation(room, currentText)

                }

            }
        }

        ColumnLayout {
                spacing: 8
                Layout.fillWidth: true

        RowLayout {
            spacing: 8; Layout.fillWidth: true


            CheckBox {
             id: econBox
             onCheckedChanged: backend.set_economy(room, checked)
             }
            Label { text: "Tryb ekonomiczny"; color: econBox.checked ? "#86AD7F" : "white"; font.pixelSize: 14 }
            }
        RowLayout {
            spacing: 8; Layout.fillWidth: true
            CheckBox { id: powerBox; onCheckedChanged: backend.set_powerful(room, checked) }
            Label { text: "Power Mode"; color: powerBox.checked ? "#AD907F" : "white"; font.pixelSize: 14 }
        }
        RowLayout {
            spacing: 8; Layout.fillWidth: true
            CheckBox { id: lowNoiseBox; onCheckedChanged: backend.set_powerful(room, checked) }
            Label { text: "Low Noise Outdoor"; color: lowNoiseBox.checked ? "#AD7F9D" : "white"; font.pixelSize: 14 }
        }
        }

        Item { Layout.fillHeight: true }
        Button {
        text: "Set"
        font.pixelSize: 16
        Layout.alignment: Qt.AlignHCenter
        background: Rectangle{
        color: "#8C99A0"
        radius: 4}
        onClicked: {
            backend.set_temperature(room, control.value)
            backend.set_mode_operation(room, currentMode)
            backend.set_economy(room, econBox.checked)
            backend.set_powerful(room, powerBox.checked)
            backend.set_low_noise(room, lowNoiseBox.checked)
 }
    }

}
Connections {
    target: backend

    function onModeReceived(mode) {
        currentMode = mode
    }

    function onTargetTemperatureReceived(temperature) {
        initialTemperature = temperature
        control.value = temperature
    }

    function onEconomyReceived(value) {
        initialEconomy = value
        econBox.checked = value
    }

    function onPowerfulReceived(value) {
        initialPowerful = value
        powerBox.checked = value
    }

    function onLowNoiseReceived(value) {
        initialLowNoise = value
        lowNoiseBox.checked = value
    }
}

}