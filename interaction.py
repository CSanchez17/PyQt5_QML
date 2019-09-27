
# Python Module interaction

import pyautogui as pa

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



def performMouseMovement(mousePosList, arg1):  
   i_EventID = 3
   index = 0
   for i_rows in mousePosList:
      if(i_rows[i_EventID] == 0) : 
         # left click
         pa.click(i_rows[0], i_rows[1], duration= 2)
      
      if(i_rows[i_EventID] == 1) : 
         # right click
         pa.rightClick(i_rows[0], i_rows[1], duration= 2)         
      
      if(i_rows[i_EventID] == 2) :
         # enter pressed
         pa.moveTo(i_rows[0], i_rows[1], duration= 2) 
         pa.press('enter')        
      
      index = index + 1
            
