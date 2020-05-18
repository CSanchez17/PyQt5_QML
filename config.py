import os
import json


import pygetwindow as gw
class Config:

    def __init__(self):       
       self.sOriginalMacroPath      = os.getcwd() + "\\Macro\\PO_Exporting_Auto_v0.2.xlsm"    
       self.sOutputFolderPath       = os.getcwd() + "\\Output\\"    
       self.sOutputMacroPath        = self.sOutputFolderPath + "PO_Exporting_Auto_v0.2.xlsm"  
       self.sBackUpFolderPath       = os.getcwd() + "\\Backup\\" 
       self.sArticlesListFilePath   = os.getcwd() + "\\ArticlesList.txt"
       self.articlesList            = []
       self.iUlyssesPID             = 23856    
       self.iExcelPID               = 9708

    def readFromJson(self):
        data = []
        pahtToJson = os.getcwd() + "\\instructions.json"
        with open(pahtToJson) as json_file:
            data = json.load(json_file)
            #for p in data['clicks']:
            #    print(p)
        return data

    def saveToJson(self, clickedList):
        windowObject = gw.getWindowsWithTitle('Ulysses')
        self.articlesList = self.getArticlesFromList()
        data = [
            clickedList,
            self.articlesList,
            self.iUlyssesPID,
            self.iExcelPID,
            windowObject[0].topleft
        ]
        with open('instructions.json', 'w') as outfile:
            json.dump(data,outfile) 


    def getConfiguration(self):
        data = self.readFromJson()
        return data

    def getArticlesFromList(self):
        with open(self.sArticlesListFilePath) as f:
            self.articlesList = f.readlines()

        self.articlesList =[x.strip() for x in self.articlesList]
        
        print(self.articlesList)
        return self.articlesList




conf = Config()
