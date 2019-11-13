import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import Model 1.0


ApplicationWindow {
    id: window
    visible: true
    color: "#00000000"
    //color: "gray"
    title: qsTr("Auto PO Export")
    width: 600
    height: 330

    maximumHeight: 340
    minimumHeight: 70
    maximumWidth: 560
    minimumWidth: 150

    property var x_PosClicked: 0
    property var y_PosClicked: 0
    property var messagePosition: x_PosClicked + ", "+ y_PosClicked

    property var messageBackground: "No actions recorded."
 
    //colors
    property var colorGreen: "#18cd4a"
    property var colorRed: "#f71414"
    property var colorWhite: "white"
    property var colorTransparent: "#00000000"
    

    signal recordStateRequired()
    onRecordStateRequired: {
        myStateGroup.state = "Recording";
        print("onRecordStateRequired");
        //window.myStateGroup.state = "Recording"
    }

    signal changeToOptions()
    onChangeToOptions:{
        optionsBtn.pressed = true
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1 {
            id: page1_
        }

        Page2 {
            id: page2_
        }
    }    

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        
        TabButton {
            id:optionsBtn
            text: qsTr("Options")            
        }
        TabButton {
            id:timerBtn
            text: qsTr("Timer")            
        }
    }   

    
    StateGroup {
        id: myStateGroup
        states: State {
            name: "Recording"
            PropertyChanges{
                    target: window
                    height: minimumHeight
                    width: minimumWidth
                }
        }
    }

        // Test model
    Model_QML{
        id: pyModel
    }    

    // Here we take the result of sum or subtracting numbers
    Connections {
        target: pyModel
 
        // Sum signal handler
        onSumResult: {
            // sum was set through arguments=['sum']
           // sumResult.text = sum
            console.log("sum: " + sum)
        }
        onNameAG_Changed:{
            page1_.agNumber = nameAG_
            print(page1_.agNumber)
        }
        onUlyssesPID_Changed:{
            page1_.uPID = pid_
            print(page1_.uPID)         
        }
    } 

    
}


