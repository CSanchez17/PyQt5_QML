

from PyQt5 import QtCore, QtGui, QtWidgets, QtQml

from PyQt5.QtWidgets import (QApplication,QWidget, QLCDNumber)

from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType, QQmlComponent
#from PyQt5.QtGui import QIcon
from PyQt5.QtCore import Qt, QUrl, pyqtProperty, QObject, pyqtSignal, pyqtSlot

import sys, time, os

import interaction
import processInfo as manager
import timer
import configManager
#import Model

################ my model ################
# This is the type that will be registered with QML.  It must be a
# sub-class of QObject.
class Model(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._nameAG = ''
        self._projectsPath = os.getcwd() + "\Projects"
        self._shoeSize = 0
        self._clickedList = []
        self._ulyssesPID = 0
        self.intac = interaction.Interactor()
        self._timer = timer.Timer()
        self._currTime = timer.getTheCurrentTime()
        self._lastPerformDate = ""

        self.createFolder(self._projectsPath)
        

    # Signal sending sum
    # Necessarily give the name of the argument through arguments=['sum']
    # Otherwise it will not be possible to get it up in QML
    sumResult = pyqtSignal(int, arguments=['sum'])      
  
    @pyqtProperty('QString')
    def projectsPath(self):
        return self._projectsPath
        
    @projectsPath.setter
    def projectsPath(self, projectsPath):
        self._projectsPath = projectsPath       
  
    @pyqtProperty('QString')
    def currTime(self):
        self._currTime = timer.getTheCurrentTime()
        return self._currTime

    @currTime.setter
    def currTime(self, currTime):
        self._currTime = currTime    

    # Getter must be declared first and bevore the setter
    @pyqtProperty('QString')
    def ulyssesPID(self):
        return self._ulyssesPID

    @ulyssesPID.setter
    def ulyssesPID(self, ulyssesPID):
        self._ulyssesPID = ulyssesPID    


    @pyqtProperty('QString')
    def lastPerformDate(self):
        return self._lastPerformDate

    # Define the setter of the 'name' property.
    @lastPerformDate.setter
    def lastPerformDate(self, lastPerformDate):
        self._lastPerformDate = lastPerformDate

    #--------------
    @pyqtProperty('QString')
    def nameAG(self):
        return self._nameAG

    # Define the setter of the 'name' property.
    @nameAG.setter
    def nameAG(self, nameAG):
        self._nameAG = nameAG

    # Define the getter of the 'shoeSize' property.  The C++ type and
    # Python type of the property is int.
    @pyqtProperty(int)
    def shoeSize(self):
        return self._shoeSize

    # Define the setter of the 'shoeSize' property.
    @shoeSize.setter
    def shoeSize(self, shoeSize):
        self._shoeSize = shoeSize
    # ------------------------------------------------- #
    # ------------------------------------------------- #

    # Slot for summing two numbers
    @pyqtSlot(int, int)
    def sum(self, arg1, arg2):
        # Sum two arguments and emit a signal
        self.sumResult.emit(arg1 + arg2)

    # Slot populate list
    @pyqtSlot(int, int, int)
    def populateMousePosList(self, arg1, arg2, arg3):
        self._clickedList.append([arg1, arg2, arg3])
        print(self._clickedList)

    # Slot reset the position list
    @pyqtSlot()
    def resetMousePosList(self):
        self._clickedList.clear()
        self.intac.clickedVectorIn.clear()
        print("clicked vector reseted")
        print(self._clickedList)

    # Slot reset the position list
    @pyqtSlot(str)
    def performAction(self, textInput = 0):
        print("Py: Performing action ...")
        self._lastPerformDate = self.intac.performMouseMovement(self._clickedList, self._nameAG, self._projectsPath)
        print("Py: Action performed.")

    # Slot reset the position list
    @pyqtSlot()
    def recordAction(self):
        print("Py: Recording action ...")
        self.intac.listenMouseEvents()
        self.intac.listenKeyboardEvents()

    # Slot reset the position list
    # return the lenght of the clicked list
    @pyqtSlot()
    def stopRecord(self):
        print("Py: Stop recording ...")
        self.intac.stopListenEvents()
        self.intac.stopListenKeyboard()
        self._clickedList = self.intac.getTheRecord()
        print("Clicks: ", len(self._clickedList))
        return len(self._clickedList)

    # Slot get the pid from qml
    @pyqtSlot(str)
    def setPID(self, arg1):
        manager.moveWindowToFront(arg1)

        
    # Slot get the set the selected date
    @pyqtSlot(str, str)
    def setDate(self, arg1, arg2):
        self._timer.setTheTimer(arg1, arg2)

    @pyqtSlot()
    def updateCurrentTime(self):
        self.currTime = timer.getTheCurrentTime

    @pyqtSlot()
    def startTheTimer(self):
        self._timer.waitForTheTime()

    @pyqtSlot()
    def saveToJson(self):
        configManager.saveToJson(self._clickedList)

    @pyqtSlot()
    def readFromJson(self):
        self._clickedList = configManager.readFromJson()
        print(self._clickedList)

    @pyqtSlot(result = list)
    def getClickedList(self):
        return self._clickedList

    @pyqtSlot(list)
    def setClickedList(self):
        self._clickedList = list

    def createFolder(self, directory):
        try:
            if not os.path.exists(directory):
                os.makedirs(directory)
        except OSError:
            print ('Error: Creating directory. ' +  directory)
    # ------------------------------------------------- #


def keyPressEvent(self, e):
    
    if e.key() == Qt.Key_Escape:
        self.close()

    

def runQML():
    app =QApplication(sys.argv)
    engine = QQmlApplicationEngine()
    #app.setWindowIcon(QIcon("icon.png"))

    # Register the Python type.  Its URI is 'People', it's v1.0 and the type
    # will be called 'Person' in QML.
    qmlRegisterType(Model, 'Model', 1, 0, 'Model_QML')

    # Create a component factory and load the QML script.
    component = QQmlComponent(engine)
    component.loadUrl(QUrl('Model.qml'))
    
    engine.load('main.qml')

    # Create an instance of the component.
    model = component.create()

    ##test
    screen_resolution = app.desktop().screenGeometry()
    width, height = screen_resolution.width(), screen_resolution.height()
    print("width: %d" % width) 
    print("height: %d" % height)

    if model is not None:
        # Print the value of the properties.
        print("The AG name is %s." % model.nameAG)
        print("The Ulysses PID is %s." % model.ulyssesPID)
    else:
        # Print all errors that occurred.
        for error in component.errors():
            print(error.toString())

    #example class
    #ex = Example()

    if not engine.rootObjects():
        return -1

    return app.exec_()


if __name__ == "__main__":
    runQML()
 #   actor.createHookManager()
 #   runAutoInteraction()
    #time.sleep(0.3)
   # sys.exit(runQML())
