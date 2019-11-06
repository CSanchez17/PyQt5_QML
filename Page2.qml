import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5

Page {
    id: page2
    property var inInterval: 1000
    property date currentDate: new Date()
    property date currentTime: new Date()
    property var dateString  : Qt.formatDate(currentDate,"ddd d MMM yyyy")
    property var pointSize: 15

    property var createdDate : new Date()

    function updateCurrentTime(){
        currentTime = new Date();        
    }

    function createDate(){
        var locale = Qt.locale();
        var timeString = "";
        if(tumblerHour.currentIndex < 10) {                
            if(tumblerMin.currentIndex < 10) {
                timeString = "0" + tumblerHour.currentIndex + " 0" + tumblerMin.currentIndex + " 00";
            }
            else{                
                timeString = "0" + tumblerHour.currentIndex + " " + tumblerMin.currentIndex + " 00";   
            }
        }
        else{                 
            if(tumblerMin.currentIndex < 10) {
                timeString = tumblerHour.currentIndex + " 0" + tumblerMin.currentIndex + " 00";
            }
            else{                
                timeString = tumblerHour.currentIndex + " " + tumblerMin.currentIndex + " 00";   
            }                 
        } 
        var dateTimeStringToConvert = dateString +" " + timeString;

        print(dateTimeStringToConvert)
        print(Date.fromLocaleString(locale, dateTimeStringToConvert, "d MM yyyy hh mm ss"));
        
        //send date to Python
        pyModel.setDate(dateTimeStringToConvert, "test")

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
            maximumDate: new Date(2020, 1, 10)

            onDoubleClicked:{
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
                    text: tumblerHour.currentIndex + " : " +tumblerMin.currentIndex
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: pointSize
                    color: "green"
                }

            }

            Row{

                Tumbler {
                    id: tumblerHour
                    width: 25
                    height: 52
                    wheelEnabled: true
                    visibleItemCount: 4
                    focusPolicy: Qt.WheelFocus
                    model: 23
                }

                Tumbler {
                    id: tumblerMin
                    width: 25
                    height: 52
                    wheelEnabled: true
                    visibleItemCount: 4
                    focusPolicy: Qt.WheelFocus
                    model: 59
                }

                Button{
                    id: apply
                    text: "Apply"
                    onPressed:{
                        createDate()
                    }
                }
            }

        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
