import QtQuick 6.3
import QtQuick.Controls 6.3


Popup {
    id: popup
    anchors.centerIn: parent
    width: 1000
    height: 800
    opacity: 0
    scale: 1
    visible: false
    modal: true
    onClosed: closePopup()
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)

    background: Rectangle {
        color: "#3498db"  // przykładowy kolor niebieski
        radius: 10
    }

    Text {
        text: "Salon"
        font.pixelSize: 36
    }

    Column {
        anchors.centerIn: parent
        spacing: 20



    Row {
        spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
    }
    MouseArea {
        anchors.fill: parent
        onClicked: { Popup.CloseOnPressOutside }
    }
    }

    enter: Transition {
        PropertyAnimation {
        properties: "opacity"
        from: 0
        to: 0.5
        duration: 1000
        easing.type: Easing.InCubic
        }
    }
    exit: Transition {
        PropertyAnimation {
        properties: "opacity"
        from: 0.5
        to: 0
        duration: 500
        easing.type: Easing.InCubic
        }
    }
}
