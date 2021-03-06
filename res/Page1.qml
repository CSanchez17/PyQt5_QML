import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

Page {
    id: page1
    property var messageBack : window.messageBackground
    property alias agNumber: text1.text
    property alias uPID: text2.text
    property alias ePID: text4.text

    Rectangle{
        id: borderMargin
        color: "white"
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
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: inputBoxs.bottom
            anchors.topMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
            wrapMode: Text.WordWrap
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

            // Projects path 
            Label {
                id: label3
                color: "black"
                text: "Projects path"
            }
            Text{
                id: text3
                width: 500
                text: qsTr(pyModel.projectsPath)
                color: "blue"
                font.pixelSize: 15
                wrapMode: Text.WordWrap
            }

            // Assembly Group Input
            Label {
                id: label1
                color: "black"
                text: "Assembly Group List"
            }
            Text {
                id: text1
                width: 200
                text: qsTr(pyModel.articlesListPath)
                color: "blue"
                font.pixelSize: 15
                wrapMode: Text.WordWrap
            }

            Row{
                spacing: 10
                //Ulysses PID input 
                Label {
                    id: label2
                    color: "black"
                    text: "Ulysses PID"
                }
                TextInput {
                    id: text2
                    width: 200
                    text: pyModel.ulyssesPID
                    color: "blue"
                    font.pixelSize: 15
                    font.italic: false
                    focus: true
                    cursorVisible: true

                    onTextChanged:{                        
                        text2.font.italic = true
                    }

                    onEditingFinished: {         
                        text2.font.italic = false
                        color = "blue"
                        pyModel.ulyssesPID = text2.text
                    }

                    validator: IntValidator{bottom: 4; top: 99999;}

                    Keys.onReturnPressed: {                 
                        text2.font.italic = false
                        focus = false
                        pyModel.ulyssesPID = text2.text
                        console.log("pyModel.ulyssesPID: " + pyModel.ulyssesPID)
                    }
                }

                //Excel PID input
                Label {
                    id: label4
                    color: "black"
                    text: "Excel PID"
                }
                TextInput {
                    id: text4
                    width: 200
                    text: pyModel.excelPID
                    color: "blue"
                    font.pixelSize: 15
                    font.italic: false
                    focus: true
                    cursorVisible: true

                    onTextChanged:{                        
                        text4.font.italic = true
                    }

                    onEditingFinished: {
                        pyModel.excelPID = text4.text               
                        text4.font.italic = false
                        color = "blue"
                    }

                    validator: IntValidator{bottom: 4; top: 99999;}

                    Keys.onReturnPressed: {                        
                        text4.font.italic = false
                        focus = false
                        pyModel.excelPID = text4.text
                        console.log("pyModel.excelPID: " + pyModel.excelPID)
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
                    target: start
                    visible: false
                }
                PropertyChanges{
                    target: reset
                    visible: false
                }
                PropertyChanges{
                    target: close
                    visible: false
                }
                PropertyChanges{
                    target: open
                    visible: false
                }
                PropertyChanges{
                    target: save
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
                    text : "Actions Recorded. Please click on \'Save\', to save the record"
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
            },
            State{
                name: "Reset"
                PropertyChanges{
                    target: txtBackground
                    text : "No actions recorded."
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
            ToolButton{
                text: qsTr("Open")
                id: open
                onPressed: pyModel.readFromJson()
            }

            ToolButton {
                text: qsTr("Record")
                id: stopAndRecord
                visible: true
                focus: true

                onPressed:{
                    console.log("presss")            
                    if(borderMargin.state !== 'Stopped' && borderMargin.state !== ''){
                        borderMargin.state = 'Stopped'
                        pyModel.stopRecord()  
                        var len = pyModel.getClickedList().length
                        print("len: ", len)
                        //if(len > 0){ start.enabled = true }
                        stopAndRecord.text= qsTr("Record")                   
                    }
                    else{
                        
                        if(text1.text !== "" && text2.text !== "" && text4.text !== ""){                     
                            //pyModel.setPID(text2.text)  
                            //pyModel.ulyssesPID = text2.text  
                            //pyModel.excelPID = text4.text                         
                            borderMargin.state = 'Recording' 
                            window.recordStateRequired()
                            stopAndRecord.text= qsTr("Stop") 
                            pyModel.recordAction()
                        }
                        else{
                            txtBackground.font.pixelSize = 18
                            txtBackground.text = "Please make sure the Excel and Ulysses PIDs are correct!"
                        }  
                    }
                    
                }

            }

            ToolButton {
                text: qsTr("Test")
                id: start
                enabled: true

                onPressed:{   
                    console.log("Start clicked")
                    if(text1.text !== "" && text2.text !== ""){                     
                        pyModel.setPID(text2.text)
                        var perfTime = pyModel.performAction("test")  
                        txtBackground.text = "Action performed " + pyModel.lastPerformDate     
                    }
                    else{
                        txtBackground.font.pixelSize = 20
                        txtBackground.text = "Please provide a valid AG number and Ulysses PID"
                    }
                }
            }
            
            ToolButton {
                text: qsTr("Reset")        
                id: reset

                onPressed:{                
                    pyModel.resetMousePosList()
                    borderMargin.state = 'Reset'
                    console.log("reset")
                }
            }

            ToolButton {
                text: qsTr("Save")
                id: save

                onPressed: {
                    console.log("save")
                    pyModel.saveToJson()
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

}
