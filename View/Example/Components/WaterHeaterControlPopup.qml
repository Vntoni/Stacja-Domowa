import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Popup {
    id: waterHeaterPopup
    Material.theme: Material.Dark
    Material.accent: Material.BlueGrey

    property string room: ""
    property string currentMode: ""
    property real initialTemperature: 65
    property real waterTemp: 40
    property bool initialGreen: false
    property bool initialBoost: false
    property bool initialMemory: false
    property bool initialProgram: false

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    width: 400
    height: 460

    background: Rectangle {
        color: Material.background
        radius: 10
    }

    onOpened: {
        waterHeaterPopup.x = (parent.width - width) / 2
        waterHeaterPopup.y = (parent.height - height) / 2
        backend.get_water_target_temp()
        backend.get_water_temp()
        backend.get_water_heater_mode()
        backend.get_water_heater_power()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // === DIAL ===
        Item {
    Layout.preferredWidth: 150
    Layout.preferredHeight: 150
    Layout.alignment: Qt.AlignHCenter

    Dial {
        id: control
        anchors.fill: parent
        from: 40
        to: 65
        stepSize: 0.5
        snapMode: Dial.SnapAlways

        // Tło okręgu
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

        // Obracający się uchwyt
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

        // Tekst temperatury
        contentItem: Text {
            text: control.value.toFixed(1) + "°C"
            font.pixelSize: 18
            color: "white"
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 51
            anchors.verticalCenterOffset: 61
        }
    }
}
        // === TRYBY ===
        ColumnLayout {
            spacing: 8
            Layout.fillWidth: true

            ButtonGroup { id: modeButton }

            Button {
                id: econButton
                checkable: true
                checked: initialGreen
                text: "Tryb ekonomiczny"
                font.pixelSize: 16
                Layout.fillWidth: true
                height: 50
                ButtonGroup.group: modeButton

                Material.background: checked ? "#558B2F" : "#546e7a"
                Material.foreground: "white"
                Material.elevation: 2
            }

            Button {
                id: memoryButton
                checkable: true
                checked: initialMemory
                text: "Memory Mode"
                font.pixelSize: 16
                Layout.fillWidth: true
                height: 50
                ButtonGroup.group: modeButton

                Material.background: checked ? "#5C6BC0" : "#546e7a"
                Material.foreground: "white"
                Material.elevation: 2
            }

            Button {
                id: boostButton
                checkable: true
                checked: initialBoost
                text: "Boost Mode"
                font.pixelSize: 16
                Layout.fillWidth: true
                height: 50
                ButtonGroup.group: modeButton

                Material.background: checked ? "#dc6f00" : "#546e7a"
                Material.foreground: "white"
                Material.elevation: 2
            }

            Button {
                id: programButton
                checkable: true
                checked: initialProgram
                text: "Program Mode"
                font.pixelSize: 16
                Layout.fillWidth: true
                height: 50
                ButtonGroup.group: modeButton

                Material.background: checked ? "#039BE5" : "#546e7a"
                Material.foreground: "white"
                Material.elevation: 2
            }
        }

        Item { Layout.fillHeight: true }

        // === PRZYCISK "SET" ===
        Button {
            text: "Set"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                backend.set_water_target_temp(control.value)
                if (econButton.checked) backend.set_water_heater_mode("GREEN")
                else if (memoryButton.checked) backend.set_water_heater_mode("IMEMORY")
                else if (programButton.checked) backend.set_water_heater_mode("PROGRAM")
                else if (boostButton.checked) backend.set_water_heater_mode("BOOST")
                messageDialog.open()
            }
            Material.background: Material.accent
            Material.foreground: Material.White
            Material.elevation: 3
        }
    }

    Connections {
        target: backend

        function onTargetTemperatureReceived(boiler, temperature) {
            initialTemperature = temperature
            control.value = temperature
        }

        function onWaterTemp(boiler, waterTemperature) {
            waterTemp = waterTemperature
        }

        function onModeOperating(mode) {
            currentMode = mode
            econButton.checked = mode === "GREEN"
            memoryButton.checked = mode === "IMEMORY"
            programButton.checked = mode === "PROGRAM"
            boostButton.checked = mode === "BOOST"
        }

        function onPowerStatus(power) {
            // Możesz dodać logikę jeśli potrzebna
        }
    }
}
