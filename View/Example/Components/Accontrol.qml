import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Basic


    Rectangle {
        id: salonRect
        width: 200
        height: 150
        color: "#222"
        radius: 10
        border.color: "white"
        border.width: 1

        MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                doubleClickEnabled: true
                onDoubleClicked: {
                    acPopup.room = "Salon"
                    acPopup.open()
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
        id: control
        text: qsTr("ON/OFF")
        onToggled:{
        control.checked ? backend.turn_on_ac('Salon'):
        backend.turn_off_ac('Salon')
        }

        indicator: Rectangle {
            implicitWidth: 48
            implicitHeight: 26
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            radius: 13
            color: control.checked ? "#17a81a" : "#ffffff"
            border.color: control.checked ? "#17a81a" : "#cccccc"

            Rectangle {
                x: control.checked ? parent.width - width : 0
                width: 26
                height: 26
                radius: 13
                color: control.down ? "#cccccc" : "#ffffff"
                border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
            }
        }

        contentItem: Text {
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? "#17a81a" : "#21be2b"
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing
        }
}
        }

    }
    Rectangle {
        id: jadalniaRect
        width: 200
        height: 150
        color: "#222"
        radius: 10
        border.color: "white"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Label {
                text: "Klimatyzacja Jadalnia"
                font.pixelSize: 18
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }


            Switch {
        id: control
        text: qsTr("ON/OFF")
        onToggled:{
        control.checked ? backend.turn_on_ac('Jadalnia'):
        backend.turn_off_ac('Jadalnia')
        }

        indicator: Rectangle {
            implicitWidth: 48
            implicitHeight: 26
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            radius: 13
            color: control.checked ? "#17a81a" : "#ffffff"
            border.color: control.checked ? "#17a81a" : "#cccccc"

            Rectangle {
                x: control.checked ? parent.width - width : 0
                width: 26
                height: 26
                radius: 13
                color: control.down ? "#cccccc" : "#ffffff"
                border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
            }
        }

        contentItem: Text {
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? "#17a81a" : "#21be2b"
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing
        }
}
        }




