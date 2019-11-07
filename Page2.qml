import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5

Page {
    id: page2
    property var inInterval: 1000
    property date currentDate: new Date()
    property date currentTime: new Date()
    property var dateString  : Qt.formatDate(currentDate,"d MM yyyy")
    property var pointSize: 15

    property var createdDate : new Date()    

    Component.onCompleted: prepareCurrentTime();

    function prepareCurrentTime(){ 
        pyModel.updateCurrentTime()
        var myString = pyModel.currTime
        var stringList = myString.split(' ')

        console.log(stringList[0], stringList[1]);
        selectedTime.text =  parseTime(stringList[0], stringList[1]);

        //set the Timer Index
        tumblerHour.currentIndex = stringList[0];
        tumblerMin.currentIndex = stringList[1];
        
    }

    function updateCurrentTime(){
        currentTime = new Date();        
    }

    function parseTime(ho, mi){
        if(ho < 10) {                
            if(mi < 10) {
                return "0" + ho + ":0" + mi;
            }
            else{                
                return "0" + ho + ":" + mi;   
            }
        }
        else{                          
            if(mi < 10) {
                return ho + ":0" + mi;
            }
            else{                
                return ho + ":" + mi;   
            }
        }
    }

    function createDate(){
        var locale = Qt.locale();
        var timeString = "";

        var dateTimeStringToConvert = dateString +" " + parseTime(tumblerHour.currentIndex,tumblerMin.currentIndex) + ":00";

        print(dateTimeStringToConvert)
        print(Date.fromLocaleString(locale, dateTimeStringToConvert, "d MM yyyy hh:mm:ss"));
        
        //send date to Python
        pyModel.setDate(dateTimeStringToConvert, "test")

        return dateTimeStringToConvert
    }


    Timer{
        id:timer
        interval: inInterval; running: false; repeat: true
        onTriggered: time.text
    }

    Row{
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        Calendar{
            id:calendar
            minimumDate: new Date()
            maximumDate: new Date(2025, 1, 10)

            onClicked:{
                currentDate = calendar.selectedDate
                dateString = Qt.formatDate(currentDate,"d MM yyyy")
                //dateString = Qt.formatDate(currentDate,"ddd d MMM yyyy")
                console.log(dateString)
            }
        }

        Column{
            id: column

            Row {
                id: rowSelectedDate
                width: 300
                height: 35
                spacing: 5

                Label {
                    id: label
                    height: 30
                    text: qsTr("Start date:")
                    verticalAlignment: Text.AlignBottom
                    font.pointSize: pointSize
                    color: "gray"
                }

                Text{
                    id: selectedDate
                    height: 30
                    text: Qt.formatDate(calendar.selectedDate,"ddd d MM yyyy")
                    verticalAlignment: Text.AlignBottom
                    font.pointSize: pointSize
                    color: "green"
                }
            }

            Label {
                id: label1
                height: 30
                text: qsTr("Repeat")
                verticalAlignment: Text.AlignVCenter
                font.pointSize: pointSize
                color: "gray"
            }

            ComboBox {
                id: comboBox
                model: ["Weekly", "Monthly", "Daily"]
            }

            Row {
                id: row1
                spacing: 5
                CheckBox {
                    id: mo
                    text: qsTr("Mo")
                }

                CheckBox {
                    id: di
                    text: qsTr("Tu")
                }

                CheckBox {
                    id: mi
                    text: qsTr("We")
                }

                CheckBox {
                    id: don
                    text: qsTr("Th")
                }
            }

            Row {
                id: row2
                spacing: 5
                CheckBox {
                    id: fr
                    text: qsTr("Fr")
                }

                CheckBox {
                    id: sa
                    text: qsTr("Sa")
                }

                CheckBox {
                    id: so
                    text: qsTr("Su")
                }
            }

            Row{
                spacing: 10
                Tumbler {
                    id: tumblerHour
                    width: 25
                    height: 52
                    wheelEnabled: true
                    visibleItemCount: 4
                    focusPolicy: Qt.WheelFocus
                    model: 24    

                    onCurrentIndexChanged:{
                        selectedTime.text = tumblerHour.currentIndex + " : " + tumblerMin.currentIndex     
                    } 
                }

                Tumbler {
                    id: tumblerMin
                    width: 25
                    height: 52
                    wheelEnabled: true
                    visibleItemCount: 4
                    focusPolicy: Qt.WheelFocus
                    model: 60

                    onCurrentIndexChanged:{
                        selectedTime.text = tumblerHour.currentIndex + " : " + tumblerMin.currentIndex     
                    } 
                }

                Label {
                    id: label2
                    height: 30
                    text: qsTr("Time")
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: pointSize
                    color: "gray"
                }

                Text{
                    id: selectedTime
                    height: 30
                    text: tumblerHour.currentIndex + " : " + tumblerMin.currentIndex 
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: pointSize
                    color: "green"
                }

            }

            Row{
                spacing: 10
                Tumbler {
                    id: tumblerTimerHours
                    width: 25
                    height: 52
                    wheelEnabled: true
                    visibleItemCount: 4
                    focusPolicy: Qt.WheelFocus
                    model: 25

                    onCurrentIndexChanged:{
                        selectedTimer.text = tumblerTimerHours.currentIndex + " Hours"     
                    } 
                }

                Label {
                    id: label3
                    height: 30
                    text: qsTr("Every")
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: pointSize
                    color: "gray"
                }

                Text{
                    id: selectedTimer
                    height: 30
                    text: tumblerTimerHours.currentIndex + " Hours"    
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: pointSize
                    color: "green"
                }

                Button{
                    id: apply
                    text: "Apply"
                    height: 30
                    width: 80
                    onPressed:{
                        //create date and set it to the messagebox
                        var str = "Actions will be performed on: \n "  + createDate();
                        messageBackground = str
                    }
                }
            }

        }
    }

}
