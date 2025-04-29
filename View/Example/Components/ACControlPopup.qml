import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Basic 2.15

Popup {
    id: acPopup
    // zamiast aliasu – zwykła property
    property string room: ""

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    width: 400; height: 400
    background: Rectangle { color: "#333"; radius: 10 }

    Component.onCompleted: {
    acPopup.x = (parent.width - acPopup.width) / 2
    acPopup.y = (parent.height - acPopup.height) / 2
}

ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 20

    // Dial i temp
    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 10


    Dial {
    id: tempDial
    snapMode: Dial.SnapAlways
    from: 16
    to: 30
    stepSize: 0.5
    value: 22
    implicitWidth: 150
    implicitHeight: 150
    onMoved: backend.set_target_temp(acPopup.room, value)

    background: Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.beginPath();
            ctx.arc(width/2, height/2, width/2 - 5, 0, 2*Math.PI);
            ctx.strokeStyle = "#17a81a";   // szary pełny okrąg
            ctx.lineWidth = 10;
            ctx.stroke();

            var angle = (tempDial.value - tempDial.from) / (tempDial.to - tempDial.from) * 2*Math.PI;
            ctx.beginPath();
            ctx.arc(width/2, height/2, width/2 - 5, -Math.PI/2, angle - Math.PI/2);
            ctx.strokeStyle = "#17a81a";   // zielony kawałek
            ctx.lineWidth = 10;
            ctx.stroke();
        }
    }

    contentItem: Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 60
        anchors.horizontalCenterOffset: 52
        text: tempDial.value.toFixed(1) + "°C"
        color: "white"
        font.pixelSize: 18
    }
}



    Text {
        text: qsTr("Temperature: ") + tempDial.value.toFixed(1) + "°C"
        color: "white"
        font.pixelSize: 16
    }
}
    // Tryb pracy
    RowLayout {
        spacing: 10
        Label {
            text: "Tryb:"
            color: "white"
        }
        ComboBox {
            id: modeBox
            model: [ "cool", "heat", "dry", "fan", "auto" ]
            currentIndex: 0
            onCurrentTextChanged: backend.set_mode_operation(acPopup.room, currentText)
        }
    }

    // Tryby: Economy & Power
    RowLayout {
        spacing: 20

       CheckBox {
            id: economyControl
            text: "Economy mode"
            onCheckedChanged: backend.set_economy_mode(acPopup.room, checked ? 1 : 0)
            // bez contentItem – działa domyślnie dobrze
            font.pixelSize: 14
            // Kolor tekstu zależny od stanu:
            palette.text: economyControl.checked ? "#17a81a" : "white"
    }

        CheckBox {
            id: powerControl
            text: "Power mode"
            onCheckedChanged: backend.set_power_mode(acPopup.room, checked ? 1 : 0)
            contentItem: Text {
                text: powerControl.text
                anchors.verticalCenterOffset: 40
                color: powerControl.checked ? "#17a81a" : "white"
            }
        }
    }

    // Spacer + zamknij w prawym dolnym rogu
    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.alignment: Qt.AlignRight

        Button {
            text: "Zamknij"
            onClicked: acPopup.close()
        }
    }
}
}