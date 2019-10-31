import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5


ApplicationWindow {
    id: window
    visible: true
    color: "#00000000"
    //color: "gray"
    title: qsTr("Auto PO Export")
    width: 550
    height: 300

    maximumHeight: 300
    minimumHeight: 300
    maximumWidth: 550
    minimumWidth: 550

    property var x_PosClicked: 0
    property var y_PosClicked: 0
    property var messagePosition: x_PosClicked + ", "+ y_PosClicked
    property var messageBackground: "No actions recorded."

    //colors
    property var colorGreen: "#18cd4a"
    property var colorRed: "#f71414"
    property var colorWhite: "white"
    property var colorTransparent: "#00000000"

    

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1 {
        }

        Page2 {
        }
    }    

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        
        TabButton {
            text: qsTr("Options")            
        }
        TabButton {
            text: qsTr("Timer")            
        }

    }   

}


