import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import Model 1.0

Page {

    Rectangle{
        id: borderMargin
        color: "lightgray"
        border.color: colorGreen
        border.width: 5
        anchors.fill : parent
        width: window.width
        height: window.height
        focus: true

        state: ""

        // Background text
        Text {
            id: txtBackground
            text: messageBackground
            anchors.horizontalCenter: borderMargin.horizontalCenter
            anchors.top: inputBoxs.bottom
            anchors.topMargin : 15
            font.pixelSize: 30
            wrapMode: Text.WordWrap
        }

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
                color: "gray"
                font.pixelSize: 15
                //font.italic: true
                focus: true
                cursorVisible: true

                onTextChanged: {
                    color = "black"
                }

                validator: IntValidator{bottom: 4; top: 99999;}

                Keys.onReturnPressed: {
                    focus = false
                    myModelQML.ulyssesPID = text2.text
                    console.log("myModelQML.ulyssesPID: " + myModelQML.ulyssesPID)
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
                    height: 60                  
                }
                PropertyChanges{
                    target: inputBoxs
                    visible: false
                }
                PropertyChanges{
                    target: tabBar
                    visible: false
                }
                PropertyChanges{
                    target: reset
                    visible: false
                }
                PropertyChanges{
                    target: start
                    visible: false
                }
                PropertyChanges{
                    target: close
                    visible: false
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
                    target: tabBar
                    visible: true
                }
                PropertyChanges{
                    target: reset
                    visible: true
                }
                PropertyChanges{
                    target: start
                    visible: true
                }
                PropertyChanges{
                    target: close
                    visible: true
                }
            }
        ]      

    }   
    
    ToolBar {
        id: controls
        anchors.bottom: borderMargin.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter    
      //  currentIndex: swipeView.currentIndex
        Row{      
            spacing: 10
            ToolButton {
                text: qsTr("Record")
                id: stopAndRecord
                visible: true
                focus: true

                onPressed:{            
                    if(borderMargin.state !== 'Stopped' && borderMargin.state !== ''){
                        borderMargin.state = 'Stopped'
                        myModelQML.stopRecord()
                        stopAndRecord.text= qsTr("Record")                   
                    }
                    else{
                        
                        if(text1.text !== "" && text2.text !== ""){                     
                            myModelQML.setPID(text2.text) 
                            borderMargin.state = 'Recording' 
                            stopAndRecord.text= qsTr("Stop") 
                            myModelQML.recordAction()  
                        }
                        else{
                            txtBackground.font.pixelSize = 20
                            txtBackground.text = "Please provide a valid AG number and Ulysses PID"
                        }  
                    }
                    console.log("borderMargin.state", borderMargin.state)
                }
            }
            
            ToolButton {
                text: qsTr("Reset")        
                id: reset

                onPressed:{                
                    myModelQML.resetMousePosList()
                    console.log("reset")
                }
            }

            ToolButton {
                text: qsTr("Start")
                id: start

                onPressed:{   
                    console.log("Start clicked")
                    if(text1.text !== "" && text2.text !== ""){                     
                        myModelQML.setPID(text2.text)
                        var perfTime = myModelQML.performAction("test")  
                        txtBackground.text = "Action performed " + myModelQML.lastPerformDate     
                    }
                    else{
                        txtBackground.font.pixelSize = 20
                        txtBackground.text = "Please provide a valid AG number and Ulysses PID"
                    }
                }
            }

            ToolButton {
                text: qsTr("Close")
                id: close

                onPressed: {
                    console.log("close")
                    Qt.quit()
                }
            }
        }
    }

/*
    Label {
        text: qsTr("You are on Page 1.")
        anchors.centerIn: parent
    }
*/
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
