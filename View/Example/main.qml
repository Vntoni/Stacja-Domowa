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

    property bool isReady: false

    ACControlPopup {
        id: acPopup
    }
    WaterHeaterControlPopup {
        id: waterHeaterPopup
    }
    // Busy Indicator Overlay
    Rectangle {
        id: loadingOverlay
        anchors.fill: parent
        color: "#303030"
        visible: !appWindow.isReady
        z: 99

        Column {
            anchors.centerIn: parent
            spacing: 20

            // Twój niestandardowy BusyIndicator
            BusyIndicator {
                id: control

                contentItem: Item {
                    implicitWidth: 64
                    implicitHeight: 64

                    Item {
                        id: item
                        x: parent.width / 2 - 32
                        y: parent.height / 2 - 32
                        width: 64
                        height: 64
                        opacity: control.running ? 1 : 0

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 250
                            }
                        }

                        RotationAnimator {
                            target: item
                            running: control.visible && control.running
                            from: 0
                            to: 360
                            loops: Animation.Infinite
                            duration: 1250
                        }

                        Repeater {
                            id: repeater
                            model: 6

                            Rectangle {
                                id: delegate
                                x: item.width / 2 - width / 2
                                y: item.height / 2 - height / 2
                                implicitWidth: 10
                                implicitHeight: 10
                                radius: 5
                                color: "#21be2b"

                                required property int index

                                transform: [
                                    Translate {
                                        y: -Math.min(item.width, item.height) * 0.5 + 5
                                    },
                                    Rotation {
                                        angle: delegate.index / repeater.count * 360
                                        origin.x: 5
                                        origin.y: 5
                                    }
                                ]
                            }
                        }
                    }
                }

                running: true
            }
        }
    }

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
                    NumberAnimation {
                        duration: 500; easing.type: Easing.OutCubic
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        smartIcon.rotation = (smartIcon.rotation + 360) % 360;
                    }
                }
            }

            Text {
                text: qsTr("Parter")
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

        }
    }


    Connections {
        target: backend

        function onReady(ready) {
            isReady = ready
            contentLoader.source = "Components/Accontrol.qml"
        }
    }
}
