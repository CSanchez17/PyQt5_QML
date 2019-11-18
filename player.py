
# Python Module interaction

import pyautogui as pa
import pythoncom
import datetime
import time, os, json

class Interactor:
   def __init__(self):
      self._counterFiles = 0
      self._nameAG = ''
      self.clickedVectorIn = []
      self.lastIndex = len(self.clickedVectorIn)
      self.interactionSpeed = 2

   def performMouseMovement(self, mousePosList, textInput = "", prjPath = "", nameOfExcelTable = ""):  
      i_EventID = 2  # column 2 for Event ID
      index = 0
      counterEnterKey = 0      

      for i_rows in mousePosList:
         x_position = i_rows[0]
         y_position = i_rows[1]
         print(i_rows)

         #pa.moveTo(x_position, y_position)
         if(i_rows[i_EventID] == "Left") : 
            # left click
            pa.leftClick(x_position, y_position)
         
         if(i_rows[i_EventID] == "Right") : 
            # right click
            pa.rightClick(x_position, y_position)

         if(i_rows[i_EventID] == "Delete") : 
            # Back
            #pa.click(x_position, y_position)
            pa.keyDown('delete')

         if(i_rows[i_EventID] == "Return") :
            # enter pressed
            #pa.moveTo(x_position, y_position, duration= 1) 
            #pa.click(x_position, y_position)

            if(counterEnterKey == 0):                 
               pa.click(x_position, y_position)             
               pa.keyDown('delete')
               pa.write(textInput)
               pa.press('enter')
               self.pause(6)
            if(counterEnterKey == 1):             
               pa.click(x_position, y_position)
               self.removeExistentTable(prjPath + "\\" + nameOfExcelTable)
               print(prjPath + "\\" + nameOfExcelTable)
               self.pause(1)
               pa.click(x_position, y_position)
               pa.keyDown('delete') 
               pa.write(prjPath + "\\" + nameOfExcelTable)
               pa.press('enter')

            counterEnterKey += 1
         
         if(i_rows[i_EventID] == "Space"):
            self.pause(6)
                  
         index = index + 1
      
      currentDT = datetime.datetime.now()    
      print(currentDT)

      print("Py: Action performed.")
      return currentDT.strftime("%d.%m.%Y %H:%M")

   def removeExistentTable(self, arg1):
      #delete file if already exits:
      if(os.path.exists(arg1)):
         os.remove(arg1)

   def pause(self, seconds):
      time.sleep(seconds)   #4 seconds
      
   def getTheRecord(self):
      print("len: ", len(self.clickedVectorIn))
      self.clickedVectorIn.pop(len(self.clickedVectorIn) - 1)
      return self.clickedVectorIn

   def readFromJson(self):
        data = []
        with open('instructions.json') as json_file:
            data = json.load(json_file)
            #for p in data['clicks']:
            #    print(p)
        return data

   def prepareEnvironmentDirectory(self):        
        print("readng data")    
        data = self.readFromJson()       
        _clickedList       = data[0]
        _nameAG            = data[1]
        _projectsPath      = data[2]
        _ulyssesPID        = data[3]
        _nameOfExcelTable  = data[4]

        print(_clickedList)
        print(_nameAG)
        print(_ulyssesPID)
        print(_projectsPath)
        print(_nameOfExcelTable)
                
        self.createFolder(os.getcwd() + "\Projects")
        self.createFolder(_projectsPath)

        self.performMouseMovement(_clickedList, _nameAG, _projectsPath, _nameOfExcelTable)


   def createFolder(self, directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print ('Error: Creating directory. ' +  directory)



actor = Interactor()
actor.prepareEnvironmentDirectory()