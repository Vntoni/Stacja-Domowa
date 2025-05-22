import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.15
import "Components"

ApplicationWindow {
    id: appWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("Sterowanie ogrzewaniem i podgrzewaniem")
    Material.theme: Material.Dark

    ACControlPopup { id: acPopup }

    ColumnLayout {
        anchors.fill: parent

        // Pasek zakładek
        TabBar {
            id: tabBar
            Layout.preferredHeight: 50

            TabButton {
                text: qsTr("Parter")
                onClicked: {
                    contentLoader.source = "Components/Accontrol.qml"
                }
            }
            TabButton {
                text: qsTr("Piętro")
                onClicked: {
                    contentLoader.source = "Components/HeaterControl.qml"
                }
            }
        }

        // Pasek nagłówka z wykorzystaniem HomeIcon
        RowLayout {
            id: headerRow
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            spacing: 10

            HomeIcon {
                id: smartIcon
                // Animacja obrotu przy kliknięciu
                Behavior on rotation {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        smartIcon.rotation = (smartIcon.rotation + 360) % 360;
                    }
                }
            }

            Text {
                text: qsTr("Parter - Klimatyzacja i Boiler")
                font.pixelSize: 28
                color: "white"
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // Loader do dynamicznego ładowania widoków
        Loader {
    id: contentLoader
    Layout.fillHeight: true
    anchors.margins: 10        // +10px odstępu
    source: "Components/Accontrol.qml"
    }

    }
}
