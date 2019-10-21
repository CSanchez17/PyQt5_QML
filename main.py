
from PyQt5.QtWidgets import (QApplication,QWidget, QLCDNumber)

from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType, QQmlComponent
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import Qt, QUrl, pyqtProperty, QObject, pyqtSignal, pyqtSlot

import sys, time

import interaction as actor
import processInfo as manager
#import Model

################ my model ################
# This is the type that will be registered with QML.  It must be a
# sub-class of QObject.
class Model(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._name = ''
        self._shoeSize = 0
        self._clickedList = []
        self._ulyssesPID = 0

    # Signal sending sum
    # Necessarily give the name of the argument through arguments=['sum']
    # Otherwise it will not be possible to get it up in QML
    sumResult = pyqtSignal(int, arguments=['sum'])    
  
    # Getter must be declared first and bevore the setter
    @pyqtProperty('QString')
    def ulyssesPID(self):
        return self._ulyssesPID

    @ulyssesPID.setter
    def ulyssesPID(self, ulyssesPID):
        self._ulyssesPID = ulyssesPID      

    # Define the getter of the 'name' property.  The C++ type of the
    # property is QString which Python will convert to and from a string.
    @pyqtProperty('QString')
    def name(self):
        return self._name

    # Define the setter of the 'name' property.
    @name.setter
    def name(self, name):
        self._name = name

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
    @pyqtProperty(int, int)
    def clickedList(self):
        return self._clickedList

    @clickedList.setter
    def clickedList(self, clickedList):
        self._clickedList = clickedList

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
        print(self._clickedList)

    # Slot reset the position list
    @pyqtSlot(str)
    def performAction(self, textInput = 0):
        print("Py: Performing action ...")
        actor.performMouseMovement(self._clickedList, self._name)
        print("Py: Action performed.")

    # Slot get the pid from qml
    @pyqtSlot(str)
    def setPID(self, arg1):
        manager.moveWindowToFront(arg1)
  
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
        print("The person's name is %s." % model.name)
        print("They wear a size %d shoe." % model.shoeSize)
    else:
        # Print all errors that occurred.
        for error in component.errors():
            print(error.toString())

    #example class
    #ex = Example()

    if not engine.rootObjects():
        return -1

    return app.exec_()


def runAutoInteraction():    
    # test 
    print(actor.add(4,5.5))


def moveMouse():
    #while True:
    actor.performMouseMovement()



if __name__ == "__main__":
    runQML()
 #   actor.createHookManager()
 #   runAutoInteraction()
    #time.sleep(0.3)
   # sys.exit(runQML())
