import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import Model 1.0

Window {
    id: window
    visible: true
    color: "#00000000"
    //color: "gray"
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

 
    Rectangle{
        id: borderMargin
        color: "lightgray"
        border.color: colorGreen
        border.width: 5
        //anchors.fill : window
        width: window.width
        height: window.height
        focus: true

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
            onPositionChanged: {
                x_PosClicked = mouseX
                y_PosClicked = mouseY
                console.log("x_PosClicked: " + x_PosClicked + ", y_PosClicked: " + y_PosClicked)
            }            
        }
         
        Keys.onEnterPressed:{
            //perform action on python
            //save the coordinates
            if (textIn.text != ""){                    
                myModelQML.populateMousePosList(x_PosClicked,y_PosClicked, 2)
            }
        } 

        Text {
            id: txtBackground
            text: messageBackground
            anchors.centerIn: borderMargin
            font.pixelSize: 30
        }

            //TextInput  
    Column{      
        anchors{
            left: parent.left
            leftMargin: 20
            top: parent.top
            topMargin: 15    
        }   
        Rectangle{            
            border.color: "black"   
            Label {
                text: "Assembly Group"
            }                 
            TextInput {
                id: textIn
                width: 200
                anchors.centerIn: parent
                text: qsTr("")
                color: "gray"
                font.pixelSize: 20
                font.italic: true
                focus: true   
                cursorVisible: true 

                onTextChanged: {   
                    color = "black"  
                }

                Keys.onReturnPressed: {
                    focus = false
                }
            }
        }  
        
        Rectangle{ 
            border.color: "black" 
            Label {
                text: "Ulysses PID"
            }                 
            TextInput {
                width: 200
                anchors.centerIn: parent
                text: qsTr("")
                color: "gray"
                font.pixelSize: 20
                font.italic: true
                focus: true   
                cursorVisible: true 

                onTextChanged: {   
                    color = "black"  
                }

                Keys.onReturnPressed: {
                    focus = false
                }
            }
        }  
    }  


        Row{
            id: controls
            spacing: 2

            anchors{
                left: parent.left
                bottom: parent.bottom
                leftMargin: 20
                bottomMargin: 20
            } 

            Rectangle {
                id: record
                width: 50
                height: 20
                color: colorWhite
                border.color: "black"

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

                TextEdit {
                    text: qsTr("Play")
                    color: "black"
                    anchors.centerIn: parent
                    font.pixelSize: 12
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        if(textIn.text == ""){
                            console.log("Please Provide an AG Number")
                        }
                        else{
                            myModelQML.performAction("test")
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
        }
        
        states:[
            State{
                name: "Recording"
                PropertyChanges {
                    target: borderMargin
                    color: colorTransparent
                    border.color: colorRed
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
    
    }

    Rectangle {
        id: messageRectange
        width:  150
        height: 20
        color: "black"

        anchors{
            right: parent.right
            bottom: parent.bottom
            rightMargin: 20
            bottomMargin: 20
        } 

        Text {
            text:   messagePosition
            color: "white"
            anchors.centerIn: parent
            font.pixelSize: 12
        }
    }
    
    // Test model
    Model_QML{
        id: myModelQML
        name: textIn.text        
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


