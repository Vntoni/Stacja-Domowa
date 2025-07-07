import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Basic 2.15

Rectangle {
    property real currentTempSalon: NaN
    property real currentTempJadalnia: NaN
    property real currentTempBoiler: NaN
    property bool acSalonPower: false
    property bool acJadalniaPower: false
    property bool waterHeaterPower: false

    Component.onCompleted: {

        Qt.callLater(function (){
        backend.get_water_heater_power()
        backend.get_mode_operation(salonRect.room)
        backend.get_mode_operation(jadalniaRect.room)
        backend.get_temp_indoor(salonRect.room)
        backend.get_temp_indoor(jadalniaRect.room)
        backend.get_water_temp()})
    }
    RowLayout {
        spacing: 20
        //anchors.centerIn: parent

        Rectangle {
            id: salonRect
            width: 200
            height: 200
            color: "#222"
            radius: 10
            border.color: "white"
            border.width: 1
            property string room: "Salon"

            signal clicked(string room)


            // Etykieta opisująca temperaturę
            Label {
                text: qsTr("Temperatura pokoju")
                color: "white"
                font.pixelSize: 14
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 8
            }
            // Wartość temperatury
            Label {
                text: currentTempSalon.toFixed(1) + "°C"
                color: "#17a81a"      // zielony, żeby odróżnić
                font.pixelSize: 18
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 28
            }

            MultiPointTouchArea {
                anchors.fill: parent
                minimumTouchPoints: 1
                maximumTouchPoints: 1

                property double lastTapTime: 0
                property double doubleTapThreshold: 400 // ms

                onPressed: {
                    var currentTime = Date.now();
                    if (currentTime - lastTapTime < doubleTapThreshold) {
                        // Double tap detected
                        acPopup.room = "Salon"
                        acPopup.open();
                    }
                    lastTapTime = currentTime;
                }
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 50
                spacing: 10

                Label {
                    text: "Klimatyzacja Salon"
                    font.pixelSize: 20
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }


                Switch {
                    id: saloncontrol
                    text: qsTr("ON/OFF")
                    onToggled: {
                        saloncontrol.checked ? backend.turn_on_ac('Salon') :
                            backend.turn_off_ac('Salon')
                    }

                    indicator: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 26
                        x: saloncontrol.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: saloncontrol.checked ? "#17a81a" : "#ffffff"
                        border.color: saloncontrol.checked ? "#17a81a" : "#cccccc"

                        Rectangle {
                            x: saloncontrol.checked ? parent.width - width : 0
                            width: 26
                            height: 26
                            radius: 13
                            color: saloncontrol.down ? "#cccccc" : "#ffffff"
                            border.color: saloncontrol.checked ? (saloncontrol.down ? "#17a81a" : "#21be2b") : "#999999"
                        }
                    }

                    contentItem: Text {
                        text: saloncontrol.text
                        font: saloncontrol.font
                        opacity: enabled ? 1.0 : 0.3
                        color: saloncontrol.down ? "#17a81a" : "#21be2b"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: saloncontrol.indicator.width + saloncontrol.spacing
                    }
                }
            }
            Timer {
                id: tempTimerSalon
                interval: 5000; running: true; repeat: true
                onTriggered: backend.get_temp_indoor(salonRect.room)
            }
        }

        Rectangle {
            id: jadalniaRect
            width: 200
            height: 200
            color: "#222"
            radius: 10
            border.color: "white"
            border.width: 1
            property string room: "Jadalnia"

            signal clicked(string room)


            // Etykieta opisująca temperaturę
            Label {
                text: qsTr("Temperatura pokoju")
                color: "white"
                font.pixelSize: 14
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 8
            }
            // Wartość temperatury
            Label {
                text: currentTempJadalnia.toFixed(1) + "°C"
                color: "#17a81a"      // zielony, żeby odróżnić
                font.pixelSize: 18
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 28
            }

            MultiPointTouchArea {
                anchors.fill: parent
                minimumTouchPoints: 1
                maximumTouchPoints: 1

                property double lastTapTime: 0
                property double doubleTapThreshold: 400 // ms

                onPressed: {
                    var currentTime = Date.now();
                    if (currentTime - lastTapTime < doubleTapThreshold) {
                        // Double tap detected
                        acPopup.room = "Jadalnia"
                        acPopup.open();
                    }
                    lastTapTime = currentTime;
                }
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 50
                spacing: 10

                Label {
                    text: "Klimatyzacja Jadalnia"
                    font.pixelSize: 20
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }


                Switch {
                    id: jadalniacontrol
                    text: qsTr("ON/OFF")
                    onToggled: {
                        jadalniacontrol.checked ? backend.turn_on_ac('Jadalnia') :
                            backend.turn_off_ac('Jadalnia')
                    }

                    indicator: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 26
                        x: jadalniacontrol.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: jadalniacontrol.checked ? "#17a81a" : "#ffffff"
                        border.color: jadalniacontrol.checked ? "#17a81a" : "#cccccc"

                        Rectangle {
                            x: jadalniacontrol.checked ? parent.width - width : 0
                            width: 26
                            height: 26
                            radius: 13
                            color: jadalniacontrol.down ? "#cccccc" : "#ffffff"
                            border.color: jadalniacontrol.checked ? (jadalniacontrol.down ? "#17a81a" : "#21be2b") : "#999999"
                        }
                    }

                    contentItem: Text {
                        text: jadalniacontrol.text
                        font: jadalniacontrol.font
                        opacity: enabled ? 1.0 : 0.3
                        color: jadalniacontrol.down ? "#17a81a" : "#21be2b"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: jadalniacontrol.indicator.width + jadalniacontrol.spacing
                    }
                }
            }
            Timer {
                id: tempTimerJadalnia
                interval: 5000; running: true; repeat: true
                onTriggered: backend.get_temp_indoor(jadalniaRect.room)
            }

            // Połącz sygnał temperatury

        }

        Rectangle {
            id: boilerRect
            width: 200
            height: 200
            color: "#222"
            radius: 10
            border.color: "white"
            border.width: 1
            property string room: "Boiler"

            signal clicked(string room)


            // Etykieta opisująca temperaturę
            Label {
                text: qsTr("Temperatura Wody")
                color: "white"
                font.pixelSize: 14
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 8
            }
            // Wartość temperatury
            Label {
                text: currentTempBoiler.toFixed(1) + "°C"
                color: "#17a81a"      // zielony, żeby odróżnić
                font.pixelSize: 18
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 28
            }

            MultiPointTouchArea {
                anchors.fill: parent
                minimumTouchPoints: 1
                maximumTouchPoints: 1

                property double lastTapTime: 0
                property double doubleTapThreshold: 400 // ms

                onPressed: {
                    var currentTime = Date.now();
                    if (currentTime - lastTapTime < doubleTapThreshold) {
                        // Double tap detected
                        waterHeaterPopup.open();
                    }
                    lastTapTime = currentTime;
                }
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 50
                spacing: 10

                Label {
                    text: "Boiler"
                    font.pixelSize: 20
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }


                Switch {
                    id: boilerControl
                    text: qsTr("ON/OFF")
                    onToggled: {
                        boilerControl.checked ? backend.turn_on_ac('Boiler') :
                            backend.turn_off_ac('Boiler')
                    }

                    indicator: Rectangle {
                        implicitWidth: 48
                        implicitHeight: 26
                        x: boilerControl.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: boilerControl.checked ? "#17a81a" : "#ffffff"
                        border.color: boilerControl.checked ? "#17a81a" : "#cccccc"

                        Rectangle {
                            x: boilerControl.checked ? parent.width - width : 0
                            width: 26
                            height: 26
                            radius: 13
                            color: boilerControl.down ? "#cccccc" : "#ffffff"
                            border.color: boilerControl.checked ? (boilerControl.down ? "#17a81a" : "#21be2b") : "#999999"
                        }
                    }

                    contentItem: Text {
                        text: boilerControl.text
                        font: boilerControl.font
                        opacity: enabled ? 1.0 : 0.3
                        color: boilerControl.down ? "#17a81a" : "#21be2b"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: boilerControl.indicator.width + boilerControl.spacing
                    }
                }
            }
            Timer {
                id: tempTimerBoiler
                interval: 5000; running: true; repeat: true
                onTriggered: backend.get_water_temp()
            }
        }
    }
    Connections {
        target: backend

        function onTempIndoorChanged(roomName, temperature) {
            if (roomName === jadalniaRect.room) {
                currentTempJadalnia = temperature
            } else if (roomName === salonRect.room) {
                currentTempSalon = temperature
            }
        }

        function onWaterTemp(boiler, temperature) {
            currentTempBoiler = temperature
        }

        function onPowerStatus(power) {
            if (power === false) {
                boilerControl.checked = false;
            } else {
                boilerControl.checked = true;
            }
        }


    function onModeReceived(room, mode) {
        if (room === salonRect.room) {
            saloncontrol.checked = mode !== "OFF";
        } else if (room === jadalniaRect.room) {
            jadalniacontrol.checked = mode !== "OFF";
        }
    }
}
}





