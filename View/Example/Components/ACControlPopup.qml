import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Popup {
    id: acPopup
    property string room: ""
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    width: 400; height: 400
    background: Rectangle { color: "#555555AA"; radius: 10 }

    Component.onCompleted: {
        acPopup.x = (parent.width - acPopup.width) / 2
        acPopup.y = (parent.height - acPopup.height) / 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Item {
            width: 150; height: 150
            Layout.alignment: Qt.AlignHCenter

            Dial {
                id: tempDial
                from: 16; to: 30; stepSize: 0.5; snapMode: Dial.SnapAlways
                value: from
                implicitWidth: parent.width; implicitHeight: parent.height
                onMoved: backend.set_target_temp(room, value)

                // Tarcza i pointer w Background
                background: Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        var cx = width / 2, cy = height / 2, r = cx - 6;
                        // Tło tarczy
                        ctx.lineWidth = 4; ctx.strokeStyle = "#777777";
                        ctx.beginPath(); ctx.arc(cx, cy, r, 0, 2 * Math.PI); ctx.stroke();
                    }
                }

                // Zmienna dla obliczeń
                property real angle: (tempDial.value - tempDial.from) / (tempDial.to - tempDial.from) * 2 * Math.PI - Math.PI / 2

                // Animacja dla wskazówki (pointer)
                property real pointerAngle: angle
                Behavior on pointerAngle {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }

                // Nowoczesny handle
                handle: Canvas {
                    id: dialHandle
                    implicitWidth: 16; implicitHeight: 16
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        ctx.fillStyle = "#17a81a";
                        ctx.beginPath();
                        ctx.moveTo(width / 2, 0);
                        ctx.lineTo(0, height);
                        ctx.lineTo(width, height);
                        ctx.closePath();
                        ctx.fill();
                    }
                }

                // Wskazówka
                Item {
                    width: 16; height: 16
                    anchors.centerIn: parent
                    Rotation {
                        id: pointerRotation
                        angle: tempDial.pointerAngle
                        origin.x: parent.width / 2
                        origin.y: parent.height / 2
                    }
                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            ctx.fillStyle = "#17a81a";
                            ctx.beginPath();
                            ctx.moveTo(width / 2, 0);
                            ctx.lineTo(0, height);
                            ctx.lineTo(width, height);
                            ctx.closePath();
                            ctx.fill();
                        }
                    }
                }

                // Wyświetlenie wartości w środku
                contentItem: Label {
                    anchors.centerIn: parent
                    text: tempDial.value.toFixed(1) + "°C"
                    color: "white"; font.pixelSize: 18
                }
            }
        }

        // Tryb pracy
        RowLayout {
            spacing: 10; Layout.fillWidth: true
            Label { text: "Tryb:"; color: "white"; font.pixelSize: 14 }
            ComboBox { model: ["cool","heat","dry","fan","auto"]; onCurrentTextChanged: backend.set_mode_operation(room, currentText) }
        }

        // Tryby Econ/Power
        RowLayout {
            spacing: 8; Layout.fillWidth: true
            CheckBox { id: econBox; onCheckedChanged: backend.set_economy(room, checked) }
            Label { text: "Tryb ekonomiczny"; color: econBox.checked ? "#17a81a" : "white"; font.pixelSize: 14 }
            CheckBox { id: powerBox; onCheckedChanged: backend.set_powerful(room, checked) }
            Label { text: "Power Mode"; color: powerBox.checked ? "#17a81a" : "white"; font.pixelSize: 14 }
        }

        // Spacer
        Item { Layout.fillHeight: true }

        // Przycisk Zamknij
        Button { text: "Zamknij"; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter; onClicked: acPopup.close() }
    }
}
