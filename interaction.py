
# Python Module interaction

import pyautogui as pa

def add(a, b):
   """This program adds two
   numbers and return the result"""
   result = a + b
   return result


def performMouseMovement():
    pa.moveTo(100,500)
    pa.moveRel(0,10)
    pa.dragTo(100,150)
    pa.dragRel(0,10)