import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import QtQuick.Dialogs

Popup {
    id: waterHeaterPopup
    property string room: ""
    property string currentMode: "" // domyślnie
    property real initialTemperature: 65
    property real waterTemp: 40
    property bool initialEconomy: false
    property bool initialPowerful: false
    property bool initialLowNoise: false
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 0.9 }
    }
    width: 400; height: 400
    background: Rectangle { color: "#7d4f6c"; radius: 10; opacity: 0.9}

    onOpened: {
        waterHeaterPopup.x = (parent.width - waterHeaterPopup.width) / 2
        waterHeaterPopup.y = (parent.height - waterHeaterPopup.height) / 2
        backend.get_water_target_temp()
        backend.get_water_temp()
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
    from: 40
    to: 65
    stepSize: 1
    snapMode: Dial.SnapAlways
    value: initialTemperature

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
        color: "#ff4444"


    }
}

        // reszta Twojego layoutu
    ButtonGroup {
        id: modeButton
        }
       ColumnLayout {
    spacing: 8
    Layout.fillWidth: true

    // Tryb ekonomiczny
    Button {
        id: econButton
        checkable :true
        text: checked ? "Tryb ekonomiczny: ON" : "Tryb ekonomiczny: OFF"
        font.pixelSize: 16
        Layout.fillWidth: true
        height: 50
        ButtonGroup.group: modeButton
        background: Rectangle {
            color: econButton.checked ? "#86AD7F" : "#4f6c7d"
            radius: 8
        }

    }

    // Memory Mode
    Button {
        id: powerButton
        checkable: true
        text: checked ? "Memory Mode: ON" : "Memory Mode: OFF"
        font.pixelSize: 16
        Layout.fillWidth: true
        height: 50
        ButtonGroup.group: modeButton
        background: Rectangle {
            color: powerButton.checked ? "#AD907F" : "#4f6c7d"
            radius: 8
        }

    }

    // Boost Mode
    Button {
        id: boostButton
        checkable: true
        text: checked ? "Boost Mode: ON" : "Boost Mode: OFF"
        font.pixelSize: 16
        Layout.fillWidth: true
        height: 50
        ButtonGroup.group: modeButton
        background: Rectangle {
            color: boostButton.checked ? "#AD7F9D" : "#4f6c7d"
            radius: 8
        }

    }
    Button {
        id: programButton
        checkable: true
        text: checked ? "Program Mode: ON" : "Program Mode: OFF"
        font.pixelSize: 16
        Layout.fillWidth: true
        height: 50
        ButtonGroup.group: modeButton
        background: Rectangle {
            color: programButton.checked ? "#ad7f86" : "#4f6c7d"
            radius: 8
        }
    }

    Item { Layout.fillHeight: true }

    // Przycisk "Set"
    Button {
        text: "Set"
        font.pixelSize: 16
        Layout.alignment: Qt.AlignHCenter
        background: Rectangle {
            color: "#8C99A0"
            radius: 4
        }
        onClicked: {
            messageDialog.open()
        }
    }
}
}

Connections {
    target: backend

        function onTargetTemperatureReceived(boiler, temperature){
            initialTemperature = temperature
        }
        function onWaterTemp(boiler, waterTemperature){
            waterTemp = waterTemperature
        }

}
MessageDialog {
            id: messageDialog
            buttons: MessageDialog.Ok
            text: "The document has been modified."
}
}


//IMEMORY = 1
  //  GREEN = 2
    //PROGRAM = 6
    //BOOST = 7