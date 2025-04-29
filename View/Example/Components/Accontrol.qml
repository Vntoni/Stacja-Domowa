import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Basic 2.15


    Rectangle {
        id: salonRect
        width: 200
        height: 150
        color: "#222"
        radius: 10
        border.color: "white"
        border.width: 1

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
            anchors.margins: 10
            spacing: 10

            Label {
                text: "Klimatyzacja Salon"
                font.pixelSize: 18
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }


            Switch {
        id: saloncontrol
        text: qsTr("ON/OFF")
        onToggled:{
        control.checked ? backend.turn_on_ac('Salon'):
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

    }




