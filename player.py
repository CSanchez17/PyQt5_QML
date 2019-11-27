
# Python Module interaction

import pyautogui as pa
import pythoncom
import datetime
from datetime import date
import time, os, sys, json

import random
import warnings
warnings.simplefilter("ignore", UserWarning)
sys.coinit_flags = 2
from pywinauto import application
from pywinauto.findwindows import WindowAmbiguousError, WindowNotFoundError

import shutil #Copy files
import win32com.client

class Interactor:
   def __init__(self):
      self._counterFiles = 0
      self._nameAG = ''
      self.clickedVectorIn = []
      self.lastIndex = len(self.clickedVectorIn)
      self.interactionSpeed = 2
      self.originalMacro = "\PO_Exporting_Auto.xlsm"
      self.localMacro = self.originalMacro

   def performMouseMovement(self, mousePosList, textInput = "", prjPath = "", nameOfExcelTable = "", _excelPID =""):  
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

            if(counterEnterKey == 0):       #AG group           
               pa.click(x_position, y_position)             
               pa.keyDown('delete')
               pa.write(textInput)
               pa.press('enter')
               self.pause(6)
            if(counterEnterKey == 1):        #Zip file 
               print("2nd Return")    
               self.pause(2)
            #   pa.doubleClick(x_position, y_position)
               #pa.click(x_position, y_position)
               pa.keyDown('delete') 
            #   zipName = nameOfExcelTable.replace(".xlsx", ".zip")
            #   zipName = zipName.replace("Table_", "")
               zipName = "Baugruppendokumente.zip"
               pa.write(prjPath + "\\" + zipName)
               print(prjPath + "\\" + zipName)
               self.removeExistentTable(prjPath + "\\" + zipName)
               pa.press('enter')
            if(counterEnterKey == 2):        #Excel Table
               print("3nd Return, ", _excelPID)    
               self.pause(1)
               self.moveWindowToFront(_excelPID)
            # get excel to the top ?
            #   pa.click(x_position, y_position)
               self.removeExistentTable(prjPath + "\\" + nameOfExcelTable)
               print(prjPath + "\\" + nameOfExcelTable)
            #   pa.click(x_position, y_position)
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
        pahtToJson = os.getcwd() + "\instructions.json"
        with open(pahtToJson) as json_file:
            data = json.load(json_file)
            #for p in data['clicks']:
            #    print(p)
        return data

   def copyMacroPO(self, srcPath):
      destination = srcPath + self.originalMacro
      print("dest: ", destination)
      self.localMacro = shutil.copyfile("PO_Exporting_Auto.xlsm", destination)

   def runMacro(self):
      if os.path.exists(self.localMacro):
         xl = win32com.client.Dispatch("Excel.Application")
         wb = xl.Workbooks.Open(os.path.abspath(self.localMacro), ReadOnly=1)
         print("Running: ", self.localMacro)
         xl.Application.Run("PO_Exporting_Auto.xlsm!Modul1.auto_PO_Exporting")
         wb.Close(True)
         print("Macro done: ", datetime.datetime.now())
         del xl

   def prepareEnvironmentDirectory(self):        
        print("readng data")    
        data = self.readFromJson()       
        _clickedList       = data[0]
        _nameAG            = data[1]
        _projectsPath      = data[2]
        _ulyssesPID        = data[3]
        _excelPID          = data[4]
        _nameOfExcelTable  = data[5]

        print(_clickedList)
        print(_nameAG)
        print(_ulyssesPID)
        print(_excelPID)
        print(_projectsPath)
        print(_nameOfExcelTable)

        self.moveWindowToFront(_excelPID)  
        self.moveWindowToFront(_ulyssesPID)   
        self.pause(1)
        #self.createFolder(os.getcwd() + "\..\Projects")
        self.createFolder(_projectsPath)
        self.copyMacroPO(_projectsPath)     
        self.performMouseMovement(_clickedList, _nameAG, _projectsPath, _nameOfExcelTable, _excelPID)
        self.runMacro()
   #     self.cleanDirectory(_projectsPath, "\\" + _nameOfExcelTable, self.localMacro, "\Baugruppendokumente.zip", "\Baugruppendokumente")

   def cleanDirectory(self, _projectsPath, _nameOfExcelTable, localMacro, zipFile, AG_Folder):
      os.remove(_projectsPath + _nameOfExcelTable)
      print("Removed file: " + _projectsPath + _nameOfExcelTable)
      os.remove(_projectsPath + zipFile)
      print("Removed file: " + _projectsPath + zipFile)
      os.remove(localMacro)
      print("Removed file: " + localMacro)
      shutil.rmtree(_projectsPath + AG_Folder, ignore_errors=True)
      print("Removed file: " + _projectsPath + AG_Folder)

   def createFolder(self, directory):
      try:
         #if not os.path.exists(directory):
         #   os.makedirs(directory)
         if os.path.exists(directory): #remove folder if already exists            
            print("Removed directory: ", directory)
            shutil.rmtree(directory, ignore_errors=True)     
                               
         os.makedirs(directory)
         
      except OSError:
         print ('Error: Creating directory. ' +  directory)

   # Select the PID window and bring it to the top
   def moveWindowToFront(self,arg1):    
      pid = int(arg1)
      app = application.Application().connect(process=pid)
      dlg = app.top_window().set_focus()
      #print(dlg)

actor = Interactor()
actor.prepareEnvironmentDirectory()
