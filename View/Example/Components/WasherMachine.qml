import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects

Rectangle {
    id: washerPill
    property bool showWhenIdle: true
    property bool online: false
    property int  remaining: -1
    property string lastSeen: ""
    layer.enabled: true
    layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: 0.35     // 0.28–0.40
            shadowBlur: 0.30
            shadowHorizontalOffset: 7
            shadowVerticalOffset: 4
            saturation: 0.2


            }

    // widoczność wg statusu
    visible: online ? (showWhenIdle || remaining > 0) : true
    z: 100

    // rozmiary pigułki
    implicitHeight: 80
    implicitWidth: 200
    radius: 30

    // tło wg stanu (zostawiam Twoje)
    color: !online ? "#b84a4a" : (remaining > 0 ? "#1f8f3a" : "#b84a4a")
    opacity: 0.95
    border.color: "#d8dfd8"; border.width: 1

    // --------- TREŚĆ ---------
    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 12         // ogólny margines pigułki
        spacing: 0

        // Ikona po lewej z lekkim marginesem
        Image {
            source: "qrc:/icons/laundry-machine.png"
            width: 56; height: 56
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.leftMargin: 6
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowOpacity: 0.25     // 0.28–0.40
                shadowBlur: 0.60
                shadowHorizontalOffset: 3
                shadowVerticalOffset: 3
                saturation: 0.1


                    }
        }

        // „sprężyna” po lewej stronie tekstu
        Item { Layout.fillWidth: true }

        // Tekst na środku – dzięki dwóm sprężynom po bokach
        Text {
            id: statusText
            text: !online ? "OFF"
                 : (remaining > 0 ? remaining + " min" : "OFF")
            color: "white"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        // „sprężyna” po prawej – żeby tekst był idealnie centrowany
        Item { Layout.fillWidth: true }
    }

    // delikatne oddychanie tylko podczas prania
    SequentialAnimation on scale {
        running: online && remaining > 0
        loops: Animation.Infinite
        NumberAnimation { from: 1.0; to: 1.06; duration: 650; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.06; to: 1.0; duration: 650; easing.type: Easing.InOutSine }
    }

    // sygnały z backendu
    Connections {
        target: backend
        function onWasherOnlineChanged(v){
            if (v === true) {
               washerPill.online = true }
               }
        function onWasherRemainingChanged(mins) { washerPill.remaining = mins }
        function onWasherLastSeenChanged(ts)    { washerPill.lastSeen = ts }
    }

    Component.onCompleted: backend.start_washer_monitor()
}
