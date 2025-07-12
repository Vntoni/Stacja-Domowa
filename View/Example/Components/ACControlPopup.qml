import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Popup {
    id: acPopup
    property string room: ""
    property string currentMode: ""
    property real initialTemperature: 21.0
    property bool initialEconomy: false
    property bool initialPowerful: false
    property bool initialLowNoise: false
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 0.9 }
    }
    width: 400; height: 460
    background: Rectangle { color: "#4f6c7d"; radius: 10; opacity: 0.9 }

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

        // === DIAL Z GLOW ===
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
                    width: 16; height: 16
                    color: control.pressed ? "#d9e8e9" : "#e9f4f5"
                    radius: 8; antialiasing: true
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

                contentItem: Text {
                    text: control.value.toFixed(1) + "°C"
                    font.pixelSize: 18; color: "white"
                    anchors.centerIn: parent
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
                color: currentMode === "HEAT" ? "#D95550"
                      : currentMode === "COOL" ? "#4F9FD9"
                      : currentMode === "DRY" ? "#FFD166"
                      : currentMode === "FAN" ? "#AAAAAA"
                      : currentMode === "OFF" ? "#3B4A55"
                      : "#66B67A"
            }
        }
        DropShadow {
        anchors.fill: modeButtons
        horizontalOffset: 1
        verticalOffset: 2
        radius: 2.0
        color: "#4e4a4a"
        source: modeButtons
    }


        // === PRZYCISKI TRYBU ===
        RowLayout {
            id: modeButtons
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
        id: buttonShadow
        text: modelData.label
        checkable: true
        checked: currentMode === modelData.label
        onClicked: currentMode = modelData.label
        Layout.fillWidth: true
        font.pixelSize: 14
        ButtonGroup.group: modeGroup

        background: Rectangle {
            radius: 8
            color: checked ? modelData.color : "#6d8495"
            border.color: "#cfd8dc"
            border.width: 1

            Behavior on color {
                ColorAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}

        }


        // === PRZYCISKI OPCJI ===
        ColumnLayout {
            id: optionsButtons
            spacing: 12; Layout.alignment: Qt.AlignHCenter

                Button {
                    id: econButton
                    text: "ECONOMY"
                    checkable: true
                    checked: initialEconomy
                    Layout.fillWidth: true
                    enabled: !powerButton.checked  // disabled jeśli POWERFUL aktywny
                    onClicked: {
                        initialEconomy = checked
                    }
                    background: Rectangle {
                    radius: 8
                    color: econButton.checked ? "#7ab666" : "#7893a3"
                    border.color: "#a7c0cd"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 300 } }
                    }
                    }
                    // POWERFUL
                Button {
                    id: powerButton
                    text: "POWERFUL"
                    checkable: true
                    checked: initialPowerful
                    Layout.fillWidth: true
                    onClicked: {
                        if (checked) {
                            // Wyłącz inne
                            econButton.checked = false
                            lowNoiseButton.checked = false
                            initialEconomy = false
                            initialLowNoise = false
                        }
                        initialPowerful = checked
                    }

                    background: Rectangle {
                        radius: 8
                        color: powerButton.checked ? "#ca322c" : "#7893a3"
                        border.color: "#a7c0cd"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }

                    // LOW NOISE
                    Button {
                        id: lowNoiseButton
                        text: "LOW NOISE"
                        checkable: true
                        checked: initialLowNoise
                        Layout.fillWidth: true
                        enabled: !powerButton.checked  // disabled jeśli POWERFUL aktywny
                        onClicked: {
                            initialLowNoise = checked
                        }

                        background: Rectangle {
                            radius: 8
                            color: lowNoiseButton.checked ? "#8d8d8d" : "#7893a3"
                            border.color: "#a7c0cd"
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 300 } }
                        }
                    }

            DropShadow {
        anchors.fill: optionsButtons
        horizontalOffset: 3
        verticalOffset: 3
        radius: 4.0
        color: "#80000000"
        source: optionsButtons
    }
                }






        Item { Layout.fillHeight: true }

        Button {
            text: "Set"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle {
                color: "#8C99A0"
                radius: 4
            }
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

        function onModeReceived(room, mode) {
            currentMode = mode
        }
        function onTargetTemperatureReceived(room, temperature) {
            initialTemperature = temperature
            control.value = temperature
        }
        function onEconomyReceived(room, value) {
            initialEconomy = value
            econBox.checked = value
        }
        function onPowerfulReceived(room, value) {
            initialPowerful = value
            powerBox.checked = value
        }
        function onLowNoiseReceived(room, value) {
            initialLowNoise = value
            lowNoiseBox.checked = value
        }
    }
}
