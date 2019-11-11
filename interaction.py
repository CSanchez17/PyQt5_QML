
# Python Module interaction

import pyautogui as pa
import pyHook
import pythoncom
import datetime
import time


class Interactor:
   def __init__(self):
      self.name = "name"
      self.age = "age"
      # create a hook manager
      self.hm = pyHook.HookManager()
      self.clickedVectorIn = []
      self.lastIndex = len(self.clickedVectorIn)
      self.interactionSpeed = 2
      
   def add(self, a, b):
      """This program adds two
      numbers and return the result"""
      result = a + b
      return result

   def performMouseMovement(self, mousePosList, textInput = "", textInput2 = ""):  
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

         if(i_rows[i_EventID] == "Back") : 
            # Back
            pa.click(x_position, y_position)
            pa.keyDown('delete')

         if(i_rows[i_EventID] == "Return") :
            # enter pressed
            #pa.moveTo(x_position, y_position, duration= 1) 
            pa.click(x_position, y_position)

            if(counterEnterKey == 0):
               pa.write(textInput)
            if(counterEnterKey == 1):
               pa.doubleClick(x_position, y_position)
               pa.write(textInput2)
               
            pa.press('enter')
            self.pause()
            counterEnterKey += 1
         
         if(i_rows[i_EventID] == "Space"):
            self.pause()
                  
         index = index + 1
      
      currentDT = datetime.datetime.now()    
      print(currentDT)
      return currentDT.strftime("%d.%m.%Y %H:%M")

   def pause(self):
      time.sleep(6)   #4 seconds


   def OnKeyboardEvent(self, event):

      print ('MessageName:',event.MessageName)
      #print ('Message:',event.Message)
      # print 'Time:',event.Time
      # print 'Window:',event.Window
      # print 'WindowName:',event.WindowName
      print ('Ascii:', event.Ascii, chr(event.Ascii))
      print ('Key:', event.Key)
      print ('KeyID:', event.KeyID)
      #print ('ScanCode:', event.ScanCode)
      # print 'Extended:', event.Extended
      # print 'Injected:', event.Injected
      #print ('Alt', event.Alt)
      #lastIndex = len(clickedVectorIn)  
      if(event.Key == "Return"):    
         self.lastIndex = len(self.clickedVectorIn) - 1
         self.clickedVectorIn.append([self.clickedVectorIn[self.lastIndex][0], self.clickedVectorIn[self.lastIndex][1],"Return"])
      if(event.Key == "Space"): 
         self.lastIndex = len(self.clickedVectorIn) - 1
         self.clickedVectorIn.append([self.clickedVectorIn[self.lastIndex][0], self.clickedVectorIn[self.lastIndex][1],"Space"])
      if(event.Key == "Back"):
         self.lastIndex = len(self.clickedVectorIn) - 1
         self.clickedVectorIn.append([self.clickedVectorIn[self.lastIndex][0], self.clickedVectorIn[self.lastIndex][1],"Back"])
 
         

      #print(clickedVectorIn[lastIndex][0], clickedVectorIn[lastIndex][1])
      return True


   def OnMouseEvent(self, event):
      print("OnMouseEvent")
      # called when mouse events are received
      msgName =  event.MessageName
      (event_x, event_y) = event.Position  
      print("mouse: ", event.Position )

      if(msgName == "mouse left down"):
         print ('MessageName:', event.MessageName)
         print("x: ", event_x)
         print("y: ", event_y)
         self.clickedVectorIn.append([event_x, event_y, "Left"])   
         #print ('WindowName:', event.WindowName)
         print ('Position:' ,event.Position)

      if(msgName == "mouse right down"):
         print ('MessageName:', event.MessageName)
         print("x: ", event_x)
         print("y: ", event_y)
         self.clickedVectorIn.append([event_x, event_y, "Right"])
         #print ('WindowName:', event.WindowName)
         print ('Position:' ,event.Position)

      return True

   def listenMouseEvents(self):
      # watch for all mouse events
      self.hm.MouseAll = self.OnMouseEvent
      # set the hook
      self.hm.HookMouse()
      # wait forever
      #pythoncom.PumpMessages()

   def stopListenEvents(self):
      self.hm.UnhookMouse()

   def listenKeyboardEvents(self):
      # watch for all mouse events
      self.hm.KeyDown = self.OnKeyboardEvent
      # set the hook
      self.hm.HookKeyboard()
      # wait forever
      #pythoncom.PumpMessages()

   def stopListenKeyboard(self):
      self.hm.UnhookKeyboard()

   def getTheRecord(self):
      print("len: ", len(self.clickedVectorIn))
      self.clickedVectorIn.pop(len(self.clickedVectorIn) - 1)
      return self.clickedVectorIn




