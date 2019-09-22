import QtQuick 2.12
import QtQuick.Window 2.12

import Model 1.0

Window {
    id: window
    visible: true
    color: "#00000000"
    title: qsTr("Auto PO Export")
    width: 800
    height: 600

    //hide min, max, close buttons title
    flags: {
        Qt.FramelessWindowHint
        //Qt.WindowMaximized
    }

    property var x_PosClicked: 0
    property var y_PosClicked: 0
    property var messagePosition: "Clicked on: " + x_PosClicked + ", "+ y_PosClicked

    //colors
    property var colorGreen: "#18cd4a"
    property var colorRed: "#f71414"
    property var colorWhite: "white"
    property var colorTransparent: "#00000000"

    MouseArea{
        anchors.fill : parent
        hoverEnabled: true

        onMouseXChanged: console.log("Mouse: "+ mouseX + ", "+mouseY );
        onClicked:{
            x_PosClicked = mouseX
            y_PosClicked = mouseY

            // add coordinates
            myModelQML.sum(5,9)
        }

    }

    // Buttons
    Rectangle{

        id: borderMargin
        anchors.fill : parent
        color: colorWhite
        border.color: colorGreen
        border.width: 5

        Rectangle {
            id: messageRectange
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10

            width:  150
            height: 20
            color: colorWhite

            Text {
                id:     element
                text:   messagePosition
                anchors.centerIn: parent
                font.pixelSize: 12
            }
        }

        Rectangle {
            id: record
            width: 50
            height: 20
            color: colorWhite
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            TextEdit {
                id: recordText
                text: qsTr("Record")
                anchors.centerIn: parent
                font.pixelSize: 12
            }

            MouseArea{
                anchors.fill: parent
                onPressed:{
                    window.showMaximized()
                    borderMargin.state = 'Recording'
                }
            }
        }

        Rectangle {
            id: stop
            width: 50
            height: 20
            color: colorWhite
            anchors.left: record.right
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            TextEdit {
                id: stopText
                text: qsTr("Stop")
                anchors.centerIn: parent
                font.pixelSize: 12
            }

            MouseArea{
                anchors.fill: parent
                onPressed:{
                    window.showNormal()
                    borderMargin.state = 'Stopped'
                }
            }
        }

        Rectangle {
            id: close
            width: 50
            height: 20
            color: colorWhite
            anchors.left: stop.right
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            TextEdit {
                id: closeText
                text: qsTr("Close")
                anchors.centerIn: parent
                font.pixelSize: 12
            }

            MouseArea{
                anchors.fill: parent
                onPressed: Qt.quit()
            }
        }

        states:[
            State{
                name: "Recording"
                PropertyChanges {
                    target: borderMargin;
                    border.color: colorRed
                    color: colorTransparent
                }
            },
            State{
                name: "Stopped"
                PropertyChanges {
                    target: borderMargin;
                    border.color: colorGreen
                    color: colorWhite
                }
            }

        ]

    }

    Model_QML{
        id: myModelQML
        
    }

    // Here we take the result of sum or subtracting numbers
    Connections {
        target: myModelQML
 
        // Sum signal handler
        onSumResult: {
            // sum was set through arguments=['sum']
           // sumResult.text = sum
            console.log("sum: " + sum)
        }
    }

}


