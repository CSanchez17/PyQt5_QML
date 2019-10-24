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

        state: "Stopped"

        // Background text
        Text {
            id: txtBackground
            text: messageBackground
            anchors.centerIn: borderMargin
            font.pixelSize: 30
        }

        // Message position  Box
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

/*
        MouseArea{
            anchors.fill : parent
            //hoverEnabled: true
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
                //console.log("x_PosClicked: " + x_PosClicked + ", y_PosClicked: " + y_PosClicked)
            }
        }

*/
        Keys.onEnterPressed:{
            //perform action on python
            //save the coordinates
            if (textIn.text != ""){
                myModelQML.populateMousePosList(x_PosClicked,y_PosClicked, 2)
            }
        }

        //TextInput
        Column{
            id: inputBoxs
            anchors{
                left: borderMargin.left
                leftMargin: 20
                top: borderMargin.top
                topMargin: 20
            }
            //firs input
            Label {
                id: label1
                text: "Assembly Group"
            }
            TextInput {
                id: text1
                width: 200
                text: qsTr("")
                color: "gray"
                font.pixelSize: 15
                //font.italic: true
                focus: true
                cursorVisible: true

                onTextChanged: {
                    color = "black"
                }

                Keys.onReturnPressed: {
                    focus = false
                    myModelQML.nameAG = text1.text
                    console.log("myModelQML.nameAG: " + myModelQML.nameAG)
                }
            }

            //second input
            Label {
                id: label2
                text: "Ulysses PID"
            }
            TextInput {
                id: text2
                width: 200
                text: qsTr("")
                selectionColor: "#060606"
                color: "#fbfbfb"
                font.pixelSize: 15
                //font.italic: true
                focus: true
                cursorVisible: true

                validator: IntValidator{bottom: 4; top: 99999;}

                onTextChanged: {
                    color = "black"
                }

                Keys.onReturnPressed: {
                    focus = false
                    myModelQML.ulyssesPID = text2.text
                    console.log("myModelQML.ulyssesPID: " + myModelQML.ulyssesPID)
                }
            }
        }

        Row{
            id: controls
            spacing: 2
            focus: true

            anchors{
                left: parent.left
                bottom: parent.bottom
                leftMargin: 10
                bottomMargin: 20
            }            

            Rectangle {
                id: stopAndRecord
                height: 20
                width: 50
                color: colorWhite
                border.color: "black"
                visible: true
                focus: true

                Text{
                    id: stopAndRecordText
                    text: qsTr("Record")
                    anchors.centerIn: parent
                    font.pixelSize: 12
                    color: "black"
                }

                MouseArea{
                    anchors.fill: stopAndRecord
                    onPressed:{
                        if(borderMargin.state !== 'Stopped'){
                            borderMargin.state = 'Stopped'
                            myModelQML.stopRecord()
                            stopAndRecordText.text= qsTr("Record")                   
                        }
                        else{
                            
                            if(text1.text !== "" && text2.text !== ""){                     
                                myModelQML.setPID(text2.text) 
                                borderMargin.state = 'Recording' 
                                stopAndRecordText.text= qsTr("Stop") 
                                myModelQML.recordAction()  
                            }
                            else{
                                console.log("Please Provide the AG Number and the Ulysses PID")
                            }   
                        }
                        console.log("borderMargin.state", borderMargin.state)
                    }     
                }
            }        

            Rectangle {
                id: reset
                width: 50
                height: 20
                color: colorWhite
                border.color: "black"

                Text {
                    text: qsTr("Reset")
                    anchors.centerIn: parent
                    font.pixelSize: 12
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        myModelQML.resetMousePosList()
                        console.log("reset")
                    }
                }
            }

            Rectangle {
                id: save
                width: 50
                height: 20
                color: colorWhite
                border.color: "black"

                Text {
                    text: qsTr("Save")
                    anchors.centerIn: parent
                    font.pixelSize: 12
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed:{                        
                        console.log("save")
                    }
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
                        if(text1.text !== "" && text2.text !== ""){                     
                            myModelQML.setPID(text2.text)
                            //myModelQML.performAction("test")       
                        }
                        else{
                            console.log("Please Provide an AG Number")
                        }   
                        console.log("Play")
                    }
                }
            }

            Rectangle {
                id: close
                width: 50
                height: 20
                color: colorWhite
                border.color: "black"

                Text {
                    text: qsTr("Close")
                    anchors.centerIn: parent
                    font.pixelSize: 12
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        console.log("close")
                        Qt.quit()
                    }
                }
            }

        }

        states:[
            State{
                name: "Recording"
                PropertyChanges {
                    target: borderMargin
                    color: "white"
                    border.color: colorRed
                }
                PropertyChanges{
                    target: txtBackground
                    text : "Recording..."
                }
                PropertyChanges{
                    target: window
                    x: 0
                    y: 0
                    width: 200
                    height: 50                   
                }
                PropertyChanges{
                    target: inputBoxs
                    visible: false
                }
                PropertyChanges{
                    target: reset
                    visible: false
                }
                PropertyChanges{
                    target: save
                    visible: false
                }
                PropertyChanges{
                    target: play
                    visible: false
                }
                PropertyChanges{
                    target: close
                    visible: false
                }
                PropertyChanges{
                    target: messageRectange
                    visible: false
                }
                PropertyChanges{
                    target: stopAndRecord                    
                    border.color: "red"
                }
                PropertyChanges{
                    target: stopAndRecordText
                    color: "red"
                }
                PropertyChanges{
                    target: controls  
                    anchors{
                        left: parent.left
                        bottom: parent.bottom
                        leftMargin: 0
                        bottomMargin: 0
                    }            
                }
            },
            State{
                name: "Stopped"
                PropertyChanges {
                    target: borderMargin;
                    border.color: colorGreen
                    color: colorWhite
                }
                PropertyChanges{
                    target: txtBackground
                    text : "Actions Recorded."
                }  
                PropertyChanges{
                    target: inputBoxs
                    visible: true
                }
                PropertyChanges{
                    target: reset
                    visible: true
                }
                PropertyChanges{
                    target: save
                    visible: true
                }
                PropertyChanges{
                    target: play
                    visible: true
                }
                PropertyChanges{
                    target: close
                    visible: true
                }
                PropertyChanges{
                    target: messageRectange
                    visible: true
                }
                PropertyChanges{
                    target: stopAndRecord
                    border.color: "black"
                }
                PropertyChanges{
                    target: stopAndRecordText
                    color: "black"
                }
                PropertyChanges{
                    target: controls  
                    anchors{
                        left: parent.left
                        bottom: parent.bottom
                        leftMargin: 10
                        bottomMargin: 20
                    }            
                }
            }
        ]

    }           

    // Test model
    Model_QML{
        id: myModelQML
        nameAG: text1.text  
        ulyssesPID: text2.text        
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


