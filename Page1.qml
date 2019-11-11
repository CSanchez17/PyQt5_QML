import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

Page {
    id: page1
    property var messageBack : window.messageBackground

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
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 30
            wrapMode: Text.WordWrap
        }

        Keys.onEnterPressed:{
            //perform action on python
            //save the coordinates
            if (textIn.text != ""){
                pyModel.populateMousePosList(x_PosClicked,y_PosClicked, 2)
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
                    pyModel.nameAG = text1.text
                }

                Keys.onReturnPressed: {
                    focus = false
                    pyModel.nameAG = text1.text
                    console.log("pyModel.nameAG: " + pyModel.nameAG)
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
                    pyModel.ulyssesPID = text2.text
                }

                validator: IntValidator{bottom: 4; top: 99999;}

                Keys.onReturnPressed: {
                    focus = false
                    pyModel.ulyssesPID = text2.text
                    console.log("pyModel.ulyssesPID: " + pyModel.ulyssesPID)
                }
            }

            //third input
            Label {
                id: label3
                text: "Projects path"
            }
            TextInput {
                id: text3
                width: 500
                text: qsTr(pyModel.projectsPath)
                color: "gray"
                font.pixelSize: 15
                focus: true
                cursorVisible: true

                onTextChanged: {
                    color = "black"
                    pyModel.projectsPath = text3.text
                }

                Keys.onReturnPressed: {
                    focus = false
                    pyModel.projectsPath = text3.text
                    console.log("pyModel.projectsPath: " + pyModel.projectsPath)
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
                    if(borderMargin.state !== 'Stopped' && borderMargin.state !== ''){
                        borderMargin.state = 'Stopped'
                        pyModel.stopRecord()  
                        var len = pyModel.getClickedList().length
                        print("len: ", len)
                        //if(len > 0){ start.enabled = true }
                        stopAndRecord.text= qsTr("Record")                   
                    }
                    else{
                        
                        if(text1.text !== "" && text2.text !== ""){                     
                            pyModel.setPID(text2.text)                             
                            borderMargin.state = 'Recording' 
                            window.recordStateRequired()
                            stopAndRecord.text= qsTr("Stop") 
                            pyModel.recordAction()
                        }
                        else{
                            txtBackground.font.pixelSize = 20
                            txtBackground.text = "Please provide a valid AG number and Ulysses PID"
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
