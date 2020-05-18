
# Python Module interaction

import datetime
import json
import os
import random
import shutil  # Copy files
import sys
import time
import warnings
from datetime import date

import pyautogui as pa
import pythoncom
import win32com.client
from pywinauto import application
from pywinauto.findwindows import WindowAmbiguousError, WindowNotFoundError
import psutil

from config import conf

warnings.simplefilter("ignore", UserWarning)
sys.coinit_flags = 2


class Interactor:
   def __init__(self):
      self.iCounterFiles = 0
      self.iUlyssesPID        = conf.iUlyssesPID
      self.iExcelPID          = conf.iExcelPID
      self.sArticlesListPath  = conf.sArticlesListFilePath
      self.originalMacro      = conf.sOriginalMacroPath
      self.sOutputMacroPath   = conf.sOutputMacroPath
      self.sProjectsPath      = conf.sOutputFolderPath
      self.sBackUpFolderPath  = conf.sBackUpFolderPath

      self.articlesList = ''
      self.clickedVectorIn = []
      self.iLastIndex = len(self.clickedVectorIn)
      self.iInteractionSpeed = 2
      
   def moveMouseTo(self, from_, to_):
      pa.moveTo(from_, to_)

   def performMouseMovement(self, prjPath = "", clickedList = 0, currentArticleNr = "",
                              iUlyssesPID = "", iExcelPID =""):  
      i_EventID = 2  # column 2 for Event ID
      index = 0
      counterEnterKey = 0   

      
      self.moveWindowToFront(iUlyssesPID)   

      for i_rows in clickedList:
         x_position = i_rows[0]
         y_position = i_rows[1]
         print(i_rows)

         while(True):
            print("While..")
            p = psutil.Process(iUlyssesPID)
            print("p.status ", p.status)
            if p.status == psutil.STATUS_WAITING or p.status != psutil.STATUS_RUNNING:
               print("waiting to Ulysses")
               break

         #pa.moveTo(x_position, y_position)
         if(i_rows[i_EventID] == "Left") : 
            # left click
            pa.leftClick(x_position, y_position)
            self.pause(2)
         
         if(i_rows[i_EventID] == "Right") : 
            # right click
            pa.rightClick(x_position, y_position)
            self.pause(2)

         if(i_rows[i_EventID] == "Delete") : 
            # Back
            #pa.click(x_position, y_position)
            pa.keyDown('delete')
            self.pause(2)

         if(i_rows[i_EventID] == "Return") :
            # enter pressed
            #pa.moveTo(x_position, y_position, duration= 1) 
            #pa.click(x_position, y_position)

            if(counterEnterKey == 0):       #Ulysses : "Artklsuchen" AG group eingabe   
               print("0th Return", currentArticleNr)            
               #pa.click(x_position, y_position)             
               pa.keyDown('delete')
               pa.write(currentArticleNr)
               pa.press('enter')
               self.pause(15)

            if(counterEnterKey == 1):        # Name of Ulysses Table Top_.xlsx
               self.moveWindowToFront(iExcelPID)  
               self.pause(2)
               print("1th Return", currentArticleNr)    
               print(prjPath + "Top_" + currentArticleNr)     
               pa.keyDown('delete')
               
               pa.write(prjPath + "Top_" + currentArticleNr)   
               pa.press('enter')
               self.pause(10)

            if(counterEnterKey == 2):        # Name of Ulysses Table .xlsx  
               self.pause(10)
               print("2th Return")   
               pa.keyDown('delete')
               pa.write(prjPath + currentArticleNr)   
               pa.press('enter')   
               self.pause(10)

            if(counterEnterKey == 3):        # Name of the Zipfile
               print("3th Return")    
               self.pause(10)
               pa.keyDown('delete') 
               zipName = currentArticleNr.replace(".xlsx", ".zip")
               #zipName = "Baugruppendokumente.zip"
               self.removeExistentTable(prjPath + zipName)
               pa.write(prjPath + zipName)
               print(zipName)
               pa.press('enter')
               self.pause(10)

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



   def copyMacroPO(self):      
      print("dest: ", self.sProjectsPath)
      self.sOriginalMacroPath = shutil.copyfile(self.originalMacro, self.sOutputMacroPath)


   def prepareEnvironmentDirectory(self):
      
      print("readng data")    
      data = conf.getConfiguration() 
      sProjectsPath      = conf.sOutputFolderPath      
      clickedList        = data[0]
      articlesList       = data[1]
      iUlyssesPID        = data[2]
      iExcelPID          = data[3]
      
      print(clickedList)
      print(articlesList)
      print(iUlyssesPID)
      print(iExcelPID)
      print(sProjectsPath)

      self.moveWindowToFront(iExcelPID)  
      self.moveWindowToFront(iUlyssesPID)   
      self.pause(1)
      #self.createFolder(os.getcwd() + "/../Projects")
      self.createFolder(sProjectsPath)
      self.copyMacroPO()     

      # Downloading Files
      self.runRecordForArticleList(sProjectsPath,clickedList, articlesList, iUlyssesPID, iExcelPID)
      self.runMacro(articlesList)
   #     self.cleanDirectory(sProjectsPath, "/" + _nameOfExcelTable, self.sOriginalMacroPath, "/Baugruppendokumente.zip", "/Baugruppendokumente")


   def runMacro(self, articlesList):
      for currentArticleNr in articlesList:
         if os.path.exists(self.sOriginalMacroPath):

            # create backup of files
            print("Creating Backup")
            self.backupExportTables(self.sProjectsPath + currentArticleNr)
            self.backupExportTables(self.sProjectsPath + "Top_" + currentArticleNr)
            zipName = currentArticleNr.replace(".xlsx", ".zip")
            self.backupExportTables(self.sProjectsPath + zipName)

            try:
               xl = win32com.client.Dispatch("Excel.Application")
               wb = xl.Workbooks.Open(os.path.abspath(self.sProjectsPath + currentArticleNr), ReadOnly=1)
            #except expression as identifier:
            #   pass
            finally:            
               print("Running: ", self.sProjectsPath + currentArticleNr)
               macroPath = self.sOutputMacroPath
               macroStartMethod = "Modul1.auto_PO_Exporting"
               print(macroPath + "!" + macroStartMethod)
               xl.Application.Run(macroPath + "!" + macroStartMethod)
               wb.Close(True)
               print("Macro done: ", datetime.datetime.now())
               del xl



   def runRecordForArticleList(self, sProjectsPath,clickedList, articlesList, iUlyssesPID, iExcelPID):
      for currentArticleNr in articlesList:
         print("performing for: ", currentArticleNr)
         timeReturned= self.performMouseMovement(sProjectsPath,clickedList, currentArticleNr, iUlyssesPID, iExcelPID)
         print(timeReturned)
         

   def backupExportTables(self, filePath):
      self.createFolder(self.sBackUpFolderPath)
      destination = self.sBackUpFolderPath
      self.sOriginalMacroPath = shutil.copyfile(filePath, destination)


   def cleanDirectory(self, sProjectsPath, _nameOfExcelTable, localMacro, zipFile, AG_Folder):
      os.remove(sProjectsPath + _nameOfExcelTable)
      print("Removed file: " + sProjectsPath + _nameOfExcelTable)
      os.remove(sProjectsPath + zipFile)
      print("Removed file: " + sProjectsPath + zipFile)
      os.remove(localMacro)
      print("Removed file: " + localMacro)
      shutil.rmtree(sProjectsPath + AG_Folder, ignore_errors=True)
      print("Removed file: " + sProjectsPath + AG_Folder)

   def createFolder(self, directory):
      try:
         #if not os.path.exists(directory):
         #   os.makedirs(directory)
         if os.path.exists(directory): #remove folder if already exists            
            print("directory exists: ", directory)
            #shutil.rmtree(directory, ignore_errors=True)     
                               
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

if __name__ == "__main__":   
   actor.prepareEnvironmentDirectory()
