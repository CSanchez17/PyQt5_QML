import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5

Page {
    id: page2
    property var inInterval: 1000
    property date currentDate: new Date()
    property var dateString  : Qt.formatDate(currentDate,"ddd d MMM yyyy")
    property var pointSize: 15


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
                dateString = Qt.formatDate(currentDate,"ddd d MMM yyyy")
                console.log(Qt.formatDate(currentDate,"ddd d MMM yyyy"))

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
                    text: dateString
                    verticalAlignment: Text.AlignBottom
                    font.pointSize: pointSize
                    color: "green"
                }
            }

            Label {
                id: label1
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
                    height: 30
                    wheelEnabled: true
                    visibleItemCount: 3
                    model: 23
                }

                Tumbler {
                    id: tumblerMin
                    width: 25
                    height: 30
                    wheelEnabled: true
                    visibleItemCount: 3
                    model: 59
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
