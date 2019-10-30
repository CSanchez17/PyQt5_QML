import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5

Page {
    id: page2
    property var inInterval: 1000 
    property date currentDate: new Date()
    property var dateString  : Qt.formatDate(currentDate,"ddd d MMM yyyy")

    Button{
        id: calenderButton
        text: qsTr("Calendar")
        anchors.top: parent.top
        anchors.left: parent.left
        width: 100
        height: 50
        onPressed:{
            calendar.visible = true
            calenderButton.focus = false
            calendar.focus = true
        }
    }
    Text{
        id: selectedDate
        width: 100
        height: 50
        anchors.left: calenderButton.right
        anchors.top: parent.top
        text: dateString
        font.pixelSize: 25
    }

    Calendar{
        id:calendar
        visible : false
        anchors.fill: parent
        navigationBarVisible: true
        weekNumbersVisible: true
        minimumDate: new Date()
        maximumDate: new Date(2020, 1, 10)

        onDoubleClicked:{
            visible = false
            page2.focus = true
            currentDate = calendar.selectedDate
            dateString = Qt.formatDate(currentDate,"ddd d MMM yyyy")
            console.log(Qt.formatDate(currentDate,"ddd d MMM yyyy")) 
            
        }
    }

    Timer{
        id:timer
        interval: inInterval; running: false; repeat: true
        onTriggered: time.text
    }
}
