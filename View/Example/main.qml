import QtQuick 6.3
import QtQuick.Controls 6.3
import QtQuick.Effects

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 1024
    title: "Home"

    Loader {
            id:popupLoader
            anchors.centerIn: parent
            onLoaded: item.open()

        }

        function loadPopup(popupFile) {
            popupLoader.source = popupFile
            stackView.currentItem.blurAnim.start()
        }
        function closePopup() {
            popupLoader.source = ""
            stackView.currentItem.blurAnimReverse.start()
        }



    TabBar {
        id:bar
        width: parent.width
        TabButton {
            height:100
            text: "Parter"
            onClicked: {
                //stackView.replace(backgroundImageParter)
                stackView.replace(parter)

            }
            }
        TabButton {
            height:100
            text: "Pietro"
            onClicked: {
                //stackView.replace(backgroundImagePietro)
                stackView.replace(pietro)

            }
            }
    }
    StackView{
        id: stackView
        initialItem: parter
        anchors.fill: parent
        width: parent.width

    }


    Component {
        id: parter

        Item {
            width: root.width
            height: root.height

            property alias blurAnim: blurAnim
            property alias blurAnimReverse: blurAnimReverse

        Image {
            id: backgroundImageParter
            anchors.fill: parent
            anchors.topMargin: 60
            anchors.bottomMargin: 50
            source: 'file:///C:/Users/85faht/Baza_Domowa/View/images/wall2.jpg'
            fillMode: Image.PreserveAspectFit


        }

        MultiEffect {
            id: blurEffect
            anchors.fill: backgroundImageParter
            source: backgroundImageParter
            blurEnabled: true
            blur: 0
            opacity: 0
        }
        PropertyAnimation {
                id:blurAnim
                target: blurEffect
                properties: "blur, opacity"
                from: 0.0, 0
                to: 0.4, 1
                duration: 1200
                easing.type: Easing.OutCubic
        }

        PropertyAnimation {
                id:blurAnimReverse
                target: blurEffect
                properties: "blur, opacity"
                from: 0.4, 1
                to: 0.0, 0
                duration: 400
                easing.type: Easing.InCubic
        }

            Rectangle{
                anchors.bottom: parent.bottom
                height: 150
                color: "transparent"
                width: parent.width


            Row {
                id: buttons
                spacing: 100
                anchors.horizontalCenter: parent.horizontalCenter

                Button
                {
                    text: "Jadalnia"
                    height: 100
                    width: 200
                }
                Button
                {
                    text: "Salon"
                    height: 100
                    width: 200
                    onClicked: {
                        loadPopup("Salon.qml")
                        console.log("przycisk klikniety")
                    }
                }
            }
    }    }
}
    Component {
        id: pietro

        Item {
            width: root.width
            height: root.height



            Image {
                id: backgroundImagePietro
                anchors.centerIn: parent
                anchors.fill: parent
                anchors.topMargin: 60
                anchors.bottomMargin: 50
                source: 'file:///C:/Users/85faht/Baza_Domowa/View/images/house.jpg'
                fillMode: Image.PreserveAspectFit

                }

            Rectangle{
                anchors.bottom: parent.bottom
                height: 150
                color: "transparent"
                width: parent.width



            Row {
                id: buttons
                spacing: 100
                anchors.horizontalCenter: parent.horizontalCenter

                Button
                {
                    text: "Jula"
                    height: 100
                    width: 200
                }
                Button
                {
                    text: "Rodzice"
                    height: 100
                    width: 200
                }
                Button
                {
                    text: "Jerzy"
                    height: 100
                    width: 200
                }
            }
        }


    }
}
}
