import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects

Popup {
    id: acPopup
    Material.theme: Material.Dark
    Material.accent: Material.BlueGrey

    property string room: ""
    property string currentMode: ""
    property real initialTemperature: 21.0
    property bool initialEconomy: false
    property bool initialPowerful: false
    property bool initialLowNoise: false
    property bool initialPowerSave: false

    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 0.9 }
    }
    width: 400; height: 460
    background: Item {                                   // <— ZMIENIONE
        // cień pod kartą (shadowOnly = rysuje sam cień)
        MultiEffect {
            id: shadow;
            anchors.fill: parent;
            source: bg;
            shadowEnabled: true;
            layer.enabled: true;
            shadowBlur: 0.2; shadowOpacity: 0.2; shadowColor: "#000000"
        }


        Rectangle {
            id: bg; anchors.fill: parent
            color: Material.background
            radius: 14
            border.color: "#ffffff22"                    // hairline
        }
    }

    onOpened: {
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

        // === DIAL ===
        Item {
    Layout.preferredWidth: 150
    Layout.preferredHeight: 150
    Layout.alignment: Qt.AlignHCenter

    Dial {
        id: control
        anchors.fill: parent
        from: 10
        to: 30
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
        RowLayout {
            spacing: 10; Layout.alignment: Qt.AlignHCenter
            ButtonGroup { id: modeGroup }

            Repeater {
                model: [
                    { label: "COOL", color: "#4F9FD9" },
                    { label: "HEAT", color: "#D95550" },
                    { label: "FAN", color: "#AAAAAA" },
                    { label: "DRY", color: "#FFD166" },
                    { label: "AUTO", color: "#66B67A" },
                    { label: "OFF", color: "#3B4A55" }
                ]

                delegate: Button {
                    text: modelData.label
                    checkable: true
                    checked: currentMode === modelData.label
                    onClicked: currentMode = modelData.label
                    Layout.fillWidth: true
                    font.pixelSize: 14
                    ButtonGroup.group: modeGroup

                    Material.background: checked ? modelData.color : "#546e7a"
                    Material.foreground: Material.White
                    Material.elevation: checked ? 3 : 1

                    contentItem: Text {
             text: modelData.label
             color: "white"
             font.pixelSize: 14
             horizontalAlignment: Text.AlignHCenter
             verticalAlignment: Text.AlignVCenter
             anchors.fill: parent
            }
                }



            }
        }

        // === OPCJE ===
        ColumnLayout {
            spacing: 12; Layout.alignment: Qt.AlignHCenter

            RowLayout {
                spacing: 10; Layout.alignment: Qt.AlignHCenter
                Button {
                    id: econButton
                    text: "ECONOMY"
                    checkable: true
                    checked: initialEconomy
                    enabled: !powerButton.checked
                    Layout.preferredWidth: (parent.width - columnSpacing) / 2

                    Layout.fillWidth: true

                    onClicked: initialEconomy = checked
                    Material.background: checked ? "#7ab666" : "#546e7a"
                    Material.foreground: enabled ? "white" : "#b0bec5"
                    Material.elevation: 2
                }

                Button {
                    id: powerSaveButton
                    text: "POWERSAVE"
                    checkable: true
                    checked: initialPowerSave
                    Layout.fillWidth: true
                    Layout.preferredWidth: (parent.width - columnSpacing) / 2

                    enabled: !powerButton.checked

                    onClicked: initialPowerSave = checked
                    Material.background: checked ? "#039BE5" : "#546e7a"
                    Material.foreground: "white"
                    Material.elevation: 3
                }


            }
            RowLayout {
                spacing: 10; Layout.alignment: Qt.AlignHCenter

                Button {
                    id: lowNoiseButton
                    text: "LOW NOISE"
                    checkable: true
                    checked: initialLowNoise
                    enabled: !powerButton.checked
                    Layout.fillWidth: true
                    Layout.preferredWidth: (parent.width - columnSpacing) / 2

                    width:20

                    onClicked: initialLowNoise = checked
                    Material.background: checked ? "#8d8d8d" : "#546e7a"
                    Material.foreground: enabled ? "white" : "#b0bec5"
                    Material.elevation: 2
                }
                Button {
                    id: powerButton
                    text: "POWERFUL"
                    checkable: true
                    checked: initialPowerful
                    Layout.fillWidth: true
                    Layout.preferredWidth: (parent.width - columnSpacing) / 2


                    onClicked: {
                        if (checked) {
                            econButton.checked = false
                            lowNoiseButton.checked = false
                            initialEconomy = false
                            initialLowNoise = false
                            initialPowerSave = false
                        }
                        initialPowerful = checked
                    }

                    Material.background: checked ? "#ca322c" : "#546e7a"
                    Material.foreground: "white"
                    Material.elevation: 3
                }
            }
        }
        Item { Layout.fillHeight: true }

         Button {
            text: "Set"
            font.pixelSize: 16
            Layout.fillWidth: true
            onClicked: {
                backend.set_temperature(room, control.value)
                backend.set_mode_operation(room, currentMode)
                backend.set_economy(room, econButton.checked)
                backend.set_powerful(room, powerButton.checked)
                backend.set_low_noise(room, lowNoiseButton.checked)
            }
            Material.background: "#29d884"
            Material.foreground: "#0f1217"
            Material.elevation: 4
        }
    }

    Connections {
        target: backend

        function onModeReceived(room, mode) {
            currentMode = mode
        }
        function onTargetTemperatureReceived(room, temperature) {
            initialTemperature = temperature
            control.value = temperature
        }
        function onEconomyReceived(room, value) {
            initialEconomy = value
            econButton.checked = value
        }
        function onPowerfulReceived(room, value) {
            initialPowerful = value
            powerButton.checked = value
        }
        function onLowNoiseReceived(room, value) {
            initialLowNoise = value
            lowNoiseButton.checked = value
        }
    }
}
