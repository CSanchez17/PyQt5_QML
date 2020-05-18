

import os
import sys
import time

import timer
from PyQt5 import QtCore, QtGui, QtQml, QtWidgets
#from PyQt5.QtGui import QIcon
from PyQt5.QtCore import QObject, Qt, QUrl, pyqtProperty, pyqtSignal, pyqtSlot
from PyQt5.QtQml import QQmlApplicationEngine, QQmlComponent, qmlRegisterType
from PyQt5.QtWidgets import QApplication, QLCDNumber, QWidget

import interaction
import processInfo as manager
from config import conf
from player import actor

#from pathlib import Path

#import Model

################ my model ################
# This is the type that will be registered with QML.  It must be a
# sub-class of QObject.
class Model(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._nameAG            = ''
        self.iUlyssesPID        = conf.iUlyssesPID
        self.iExcelPID          = conf.iExcelPID
        self.sProjectsPath      = conf.sOutputFolderPath
        self.sArticlesListPath  = conf.sArticlesListFilePath
        self.articlesList       = []
        self.clickedList        = []

        self._shoeSize = 0
        self.intac      = interaction.Interactor()
        self._timer     = timer.Timer()
        self._currTime  = timer.getTheCurrentTime()
        self._lastPerformDate = ""
          
        self.createFolder(self.sProjectsPath)  
                
    ## ------------------------------------------------------------------- ##
    # Signal sending sum
    # Necessarily give the name of the argument through arguments=['sum']
    # Otherwise it will not be possible to get it up in QML
    sumResult = pyqtSignal(int, arguments=['sum'])    
    
    # Slot for summing two numbers
    @pyqtSlot(int, int)
    def sum(self, arg1, arg2):
        # Sum two arguments and emit a signal
        self.sumResult.emit(arg1 + arg2)

    # signal name changed
    nameAG_Changed  =  pyqtSignal(str, arguments=['nameAG_']) 
    # signal PID changed
    ulyssesPID_Changed  =  pyqtSignal(str, arguments=['pid_']) 
    # signal PID changed
    excelPID_Changed  =  pyqtSignal(str, arguments=['pid_']) 
    
    
    ## ------------------------------------------------------------------- ##
    @pyqtProperty('QString')
    def projectsPath(self):
        return self.sProjectsPath
        
  
    @pyqtProperty('QString')
    def currTime(self):
        self._currTime = timer.getTheCurrentTime()
        return self._currTime

    @currTime.setter
    def currTime(self, currTime):
        self._currTime = currTime    

    # Getter must be declared first and bevore the setter
    @pyqtProperty('int')
    def ulyssesPID(self):
        return self.iUlyssesPID

    @ulyssesPID.setter
    def ulyssesPID(self, ulyssesPID):
        self.iUlyssesPID = ulyssesPID    

    # Getter must be declared first and bevore the setter
    @pyqtProperty('int')
    def excelPID(self):
        return self.iExcelPID

    @excelPID.setter
    def excelPID(self, excelPID):
        self.iExcelPID = excelPID   

    @pyqtProperty('QString')
    def articlesListPath(self):
        return self.sArticlesListPath

    #---------------------------------------------------------

    @pyqtProperty('QString')
    def lastPerformDate(self):
        return self._lastPerformDate

    # Define the setter of the 'name' property.
    @lastPerformDate.setter
    def lastPerformDate(self, lastPerformDate):
        self._lastPerformDate = lastPerformDate

    @pyqtProperty('QString')
    def nameAG(self):
        return self._nameAG

    # Define the setter of the 'name' property.
    @nameAG.setter
    def nameAG(self, nameAG):
        if (self._nameAG != nameAG):
            print("setter")
            self._nameAG = nameAG
            #self.sProjectsPath = self.sProjectsPath + "/" + str(self._nameAG)
            #self._nameOfExcelTable = "Table_" + self._nameAG + ".xlsx"
            self.createFolder(self.sProjectsPath)
            print(self._nameAG)  
            print(self.sProjectsPath)

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

    # Slot populate list
    @pyqtSlot(int, int, int)
    def populateMousePosList(self, arg1, arg2, arg3):
        self.clickedList.append([arg1, arg2, arg3])
        print(self.clickedList)

    # Slot reset the position list
    @pyqtSlot()
    def resetMousePosList(self):
        self.clickedList.clear()
        self.intac.clickedVectorIn.clear()
        print("clicked vector reseted")
        print(self.clickedList)

    # Slot reset the position list
    @pyqtSlot(str)
    def performAction(self, textInput = 0): 
        print("Py: Performing action ...")
        self._nameOfExcelTable = "Table_" + self._nameAG + ".xlsx"    
        self._lastPerformDate = actor.performMouseMovement(self.sProjectsPath, self.clickedList,
                                                        self.articlesList, self.iUlyssesPID, self.iExcelPID)
        
    # Slot reset the position list
    @pyqtSlot()
    def recordAction(self):
        print("Py: Recording action ...")  

        try:
            manager.moveWindowToFront(self.iExcelPID)
            manager.moveWindowToFront(self.iUlyssesPID)

            if len(self.clickedList) == 0:
                self.intac.moveMouseTo(1000, 1000) 
            else:
                self.intac.moveMouseTo(self.clickedList[0][0], self.clickedList[0][1]) 

        except manager.application.ProcessNotFoundError:
            print("Programm PID nicht gefunden!")

        finally:
            self.intac.listenMouseEvents()
            self.intac.listenKeyboardEvents()


    # Slot reset the position list
    # return the lenght of the clicked list
    @pyqtSlot()
    def stopRecord(self):
        print("Py: Stop recording ...")
        self.intac.stopListenEvents()
        self.intac.stopListenKeyboard()
        self.clickedList = self.intac.getTheRecord()
        print("Clicks: ", len(self.clickedList))
        return len(self.clickedList)

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
        conf.saveToJson(self.clickedList)
        #self._nameOfExcelTable = "Table_" + self._nameAG + ".xlsx"
        #configManager.saveToJson(self.clickedList, self._nameAG, self.sProjectsPath, self.iUlyssesPID, self.iExcelPID, self._nameOfExcelTable)

    @pyqtSlot()
    def readFromJson(self):    
        print("readng data")    
        data = conf.readFromJson()        
        self.clickedList    = data[0]
        self.articlesList   = data[1]
        self.iUlyssesPID    = data[2]
        self.iExcelPID      = data[3]

        print(self.clickedList)
        print(self._nameAG)
        print(self.iUlyssesPID)
        print(self.iExcelPID)
        self.nameAG_Changed.emit(self._nameAG)
        self.excelPID_Changed.emit(self.iExcelPID)
        self.ulyssesPID_Changed.emit(self.iUlyssesPID)

        print(self.sProjectsPath)
        self.createFolder(os.getcwd() + "/../Projects")
        self.createFolder(self.sProjectsPath)

    @pyqtSlot(result = list)
    def getClickedList(self):
        return self.clickedList

    @pyqtSlot(list)
    def setClickedList(self):
        self.clickedList = list

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
    component.loadUrl(QUrl('res/Model.qml'))
    
    engine.load('res/main.qml')

    # Create an instance of the component.
    model = component.create()

    ##test
    screen_resolution = app.desktop().screenGeometry()
    width, height = screen_resolution.width(), screen_resolution.height()
    #print("width: %d" % width) 
    #print("height: %d" % height)

    if model is not None:
        # Print the value of the properties.
        print("The AG name is %s." % model.nameAG)
        print("The Ulysses PID is %s." % model.ulyssesPID)
        print("The Excel PID is %s." % model.excelPID)
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
