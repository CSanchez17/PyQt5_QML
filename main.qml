import QtQuick 2.12
import QtQuick.Window 2.12

import Model 1.0

Window {
    id: window
    visible: true
    color: "#00000000"
    title: qsTr("Auto PO Export")
    width: 550
    height: 200

    //hide min, max, close buttons title
    flags: {
        Qt.FramelessWindowHint
        //Qt.ItemIsDragEnabled
        //Qt.WindowMaximized
    }

    property var x_PosClicked: 0
    property var y_PosClicked: 0
    property var messagePosition: x_PosClicked + ", "+ y_PosClicked
    property var messageBackground: "Click on record"

    //colors
    property var colorGreen: "#18cd4a"
    property var colorRed: "#f71414"
    property var colorWhite: "white"
    property var colorTransparent: "#00000000"

    MouseArea{
        anchors.fill : parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

       // onMouseXChanged: console.log("Mouse: "+ mouseX + ", "+mouseY );
        onClicked:{
            x_PosClicked = mouseX
            y_PosClicked = mouseY

            if (borderMargin.state === 'Recording'){

                // add coordinates
                //myModelQML.sum(x_PosClicked,y_PosClicked)
                if (mouse.button === Qt.RightButton){
                    myModelQML.populateMousePosList(x_PosClicked,y_PosClicked, 0)
                }                    
                if (mouse.button === Qt.LeftButton){
                    myModelQML.populateMousePosList(x_PosClicked,y_PosClicked, 1)
                }
            }
        }
    }

    // Buttons
    Rectangle{

        id: borderMargin
        anchors.fill : parent
        color: "lightgray"
        border.color: colorGreen
        border.width: 5
        focus: true

        Text {
            id: txtBackground
            text: messageBackground
            anchors.centerIn: parent
            anchors.fill: parent.fill
            font.pixelSize: 30
        }

        Rectangle {
            id: messageRectange
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10

            width:  150
            height: 20
            color: "black"

            Text {
                id:     element
                text:   messagePosition
                color: "white"
                anchors.centerIn: parent
                font.pixelSize: 12
            }
        }

        Rectangle {
            id: record
            width: 50
            height: 20
            color: colorWhite
            border.color: "black"
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
            border.color: "black"
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
            id: reset
            width: 50
            height: 20
            color: colorWhite
            border.color: "black"
            anchors.left: stop.right
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            TextEdit {
                text: qsTr("Reset")
                anchors.centerIn: parent
                font.pixelSize: 12
            }

            MouseArea{
                anchors.fill: parent
                onPressed:{
                    myModelQML.resetMousePosList()
                }
            }
        }

        Rectangle {
            id: save
            width: 50
            height: 20
            color: colorWhite
            border.color: "black"
            anchors.left: reset.right
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            TextEdit {
                text: qsTr("Save")
                anchors.centerIn: parent
                font.pixelSize: 12
            }

            MouseArea{
                anchors.fill: parent
                //onPressed: Qt.quit()
            }
        }

        Rectangle {
            id: play
            width: 50
            height: 20
            color: "lightgreen"
            border.color: "black"
            anchors.left: save.right
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            TextEdit {
                text: qsTr("Play")
                color: "black"
                anchors.centerIn: parent
                font.pixelSize: 12
            }

            MouseArea{
                anchors.fill: parent
                onPressed:{
                    if(textIn.text != "  AG number  "){
                        //perform action on python
                        messagePosition = "Performing action"
                        myModelQML.performAction(textIn.text)
                        messagePosition = "Action performed"
                    }
                    else{
                        console.log("Please Provide an AG Number")
                    }

                }
            }
        }

        Rectangle {
            id: close
            width: 50
            height: 20
            color: colorWhite
            border.color: "black"
            anchors.left: play.right
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            TextEdit {
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
                /*PropertyChanges{
                    target: window
                    flags : Qt.FramelessWindowHint
                }*/
            },
            State{
                name: "Stopped"
                PropertyChanges {
                    target: borderMargin;
                    border.color: colorGreen
                    color: colorWhite
                }
                /*PropertyChanges{
                    target: window
                    flags : 
                }*/
            }

        ]

            
        Keys.onEnterPressed:{
            myModelQML.populateMousePosList(x_PosClicked,y_PosClicked, 2)
        } 

    }
    
    //TextInput  
    Rectangle{ 
        width: textIn.width + 5
        height: textIn.height + 5     
        border.color: "black"
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 15           
        TextInput {
            id: textIn
            anchors.centerIn: parent
            text: qsTr("  AG number  ")
            color: "gray"
            font.pixelSize: 20
            font.italic: true     

            onTextChanged: {                
                font.italic = false    
            }
        }
    }  

    // Test model
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


