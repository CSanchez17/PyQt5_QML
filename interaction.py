
# Python Module interaction

import pyautogui as pa
import pyHook
import pythoncom

# create a hook manager
hm = pyHook.HookManager()
clickedVectorIn = []
lastIndex = len(clickedVectorIn)

def add(a, b):
   """This program adds two
   numbers and return the result"""
   result = a + b
   return result


def performMouseMovement_v1(mousePosList, arg1):
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


def performMouseMovement_v2(mousePosList, arg1):
   pa.moveTo(mousePosList[0][0], mousePosList[0][1], duration = 1) 
   pa.click(mousePosList[0][0], mousePosList[0][1])
   pa.typewrite(arg1) 
   pa.press('enter')
   pa.moveTo(mousePosList[1][0], mousePosList[1][1], duration = 6)
   pa.rightClick(mousePosList[1][0], mousePosList[1][1])
   pa.click(mousePosList[1][0] + 20, mousePosList[1][1] - (150), duration=2)



def performMouseMovement(mousePosList, textInput = ""):  
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

def OnKeyboardEvent(event):

   print ('MessageName:',event.MessageName)
   print ('Message:',event.Message)
   # print 'Time:',event.Time
   # print 'Window:',event.Window
   # print 'WindowName:',event.WindowName
   print ('Ascii:', event.Ascii, chr(event.Ascii))
   print ('Key:', event.Key)
   print ('KeyID:', event.KeyID)
   print ('ScanCode:', event.ScanCode)
   # print 'Extended:', event.Extended
   # print 'Injected:', event.Injected
   print ('Alt', event.Alt)
   #lastIndex = len(clickedVectorIn)
   lastIndex = lastIndex - 1
   clickedVectorIn.append([clickedVectorIn[lastIndex][0], clickedVectorIn[lastIndex][1],"Return"])
   #print(clickedVectorIn[lastIndex][0], clickedVectorIn[lastIndex][1])


def OnMouseEvent(event):
   # called when mouse events are received
   msgName =  event.MessageName
   (event_x, event_y) = event.Position    

   if(msgName == "mouse left down"):
      print ('MessageName:', event.MessageName)
      print("x: ", event_x)
      print("y: ", event_y)
      clickedVectorIn.append([event_x, event_y, "left"])
      #print ('WindowName:', event.WindowName)
      print ('Position:' ,event.Position)

   if(msgName == "mouse right down"):
      print ('MessageName:', event.MessageName)
      print("x: ", event_x)
      print("y: ", event_y)
      clickedVectorIn.append([event_x, event_y, "right"])
      lastIndex =
      #print ('WindowName:', event.WindowName)
      print ('Position:' ,event.Position)

   return True


def listenMouseEvents():
   # watch for all mouse events
   hm.MouseAll = OnMouseEvent
   # set the hook
   hm.HookMouse()
   # wait forever
   #pythoncom.PumpMessages()

def stopListenEvents():
   hm.UnhookMouse()

def listenKeyboardEvents():
   # watch for all mouse events
   hm.KeyDown = OnKeyboardEvent
   # set the hook
   hm.HookKeyboard()
   # wait forever
   #pythoncom.PumpMessages()

def stopListenKeyboard():
   hm.UnhookKeyboard()

def getTheRecord():
   return clickedVectorIn
   