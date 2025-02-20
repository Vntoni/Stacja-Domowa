import QtQuick 6.3
import QtQuick.Controls 6.3

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 1024
    title: "Home"

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: 'file:///C:/Users/85faht/Baza_Domowa/View/images/wall2.jpg'
        fillMode: Image.PreserveAspectFit

    }

    TabBar {
        id:bar
        width: parent.width
        TabButton {
            height:100
            text: "Parter"
            onClicked: {
                stackView.push(parter)
            }
            }
        TabButton {
            height:100
            text: "Pietro"
            onClicked: {
                stackView.push(pietro)
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

        Rectangle{
            anchors.bottom: parent.bottom
            height: 150
            color: "transparent"

            Row {
                id: buttons
                spacing: 100
                anchors.centerIn: parent

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
                }
            }
        }
}
    Component {
        id: pietro

        Rectangle{
            anchors.bottom: parent.bottom
            height: 150
            color: "transparent"

            Row {
                id: buttons
                spacing: 100
                anchors.centerIn: parent

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
