
# Python Module interaction

import pyautogui as pa
import pyHook
import pythoncom

class Interactor:
   def __init__(self):
      self.name = "name"
      self.age = "age"
      # create a hook manager
      self.hm = pyHook.HookManager()
      self.clickedVectorIn = []
      self.lastIndex = len(self.clickedVectorIn)
      
   def add(self, a, b):
      """This program adds two
      numbers and return the result"""
      result = a + b
      return result

   def performMouseMovement_v1(self, mousePosList, arg1):
      #pa.moveTo(100,500, duration = 5)   # duration 5 sec
      #pa.moveRel(0,10, duration = 5)
      #pa.dragTo(100,150, duration = 5)
      #pa.dragRel(0,10, duration = 5)
      #print(mousePosList)
      for row in mousePosList:
         pa.moveTo(row[0],row[1], duration = 2) 
         pa.click(row[0],row[1])
         pa.typewrite(arg1) 
         pa.press('enter')
         
         #print(row)
         #for elem in row:
            #print(elem, end=' ') prints: x1 y1   
         #print()

   def performMouseMovement_v2(self, mousePosList, arg1):
      pa.moveTo(mousePosList[0][0], mousePosList[0][1], duration = 1) 
      pa.click(mousePosList[0][0], mousePosList[0][1])
      pa.typewrite(arg1) 
      pa.press('enter')
      pa.moveTo(mousePosList[1][0], mousePosList[1][1], duration = 6)
      pa.rightClick(mousePosList[1][0], mousePosList[1][1])
      pa.click(mousePosList[1][0] + 20, mousePosList[1][1] - (150), duration=2)



   def performMouseMovement(self, mousePosList, textInput = ""):  
      i_EventID = 2  # column 2 for Event ID
      index = 0
      for i_rows in mousePosList:
         x_position = i_rows[0]
         y_position = i_rows[1]

         if(i_rows[i_EventID] == 0) : 
            # left click
            pa.click(x_position, y_position, duration= 2)
         
         if(i_rows[i_EventID] == 1) : 
            # right click
            pa.rightClick(x_position, y_position, duration= 2)         
         
         if(i_rows[i_EventID] == 2) :
            # enter pressed
            pa.moveTo(x_position, y_position, duration= 2) 
            pa.click(x_position, y_position, duration= 2)
            pa.write(textInput)
            pa.press('enter')     
                  
         index = index + 1

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
      self.lastIndex = len(self.clickedVectorIn) - 1
      print("lastIndex: ", self.lastIndex)
      self.clickedVectorIn.append([self.clickedVectorIn[self.lastIndex][0], self.clickedVectorIn[self.lastIndex][1],"Return"])
      
      print("new: ", self.clickedVectorIn[self.lastIndex + 1])
      #print(clickedVectorIn[lastIndex][0], clickedVectorIn[lastIndex][1])
      return True


   def OnMouseEvent(self, event):
      # called when mouse events are received
      msgName =  event.MessageName
      (event_x, event_y) = event.Position  

      if(msgName == "mouse left down"):
         print ('MessageName:', event.MessageName)
         print("x: ", event_x)
         print("y: ", event_y)
         self.clickedVectorIn.append([event_x, event_y, "left"])   
         #print ('WindowName:', event.WindowName)
         print ('Position:' ,event.Position)

      if(msgName == "mouse right down"):
         print ('MessageName:', event.MessageName)
         print("x: ", event_x)
         print("y: ", event_y)
         self.clickedVectorIn.append([event_x, event_y, "right"])
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
      return self.clickedVectorIn
      


