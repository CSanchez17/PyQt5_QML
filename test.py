import os
from config import conf

#import pywin32
import win32gui, win32process

import pygetwindow as gw


import psutil

def testSaveConfiguration():
    print("saving data")    
    data = conf.getArticlesFromList()

    testClickedList = [[1012, 223, 'Left'], [1333, 282, 'Left'], [1333, 282, 'Return'], [1229, 332, 'Right'], [1354, 489, 'Left'], [1354, 489, 'Return'], [1354, 489, 'Space'], [1354, 489, 'Space'], [1229, 329, 'Right'], [1349, 432, 'Left'], [1349, 432, 'Space'], [1250, 218, 'Right'], [1326, 275, 'Left'], [1535, 267, 'Left'], [1723, 150, 'Left'], [1723, 150, 'Left'], [67, 66, 'Left'], [117, 124, 'Left'], [117, 124, 'Return'], [1130, 76, 'Left']]

    conf.saveToJson(testClickedList)
    print(data)
    

def testReadConfiguration():  
    print("reading data")    
    data = conf.readFromJson()        
    clickedList    = data[0]
    articlesList   = data[1]
    iUlyssesPID    = data[2]
    iExcelPID      = data[3]

    print(clickedList)
    print(articlesList)
    print(iUlyssesPID)
    print(iExcelPID)



def callback(hwnd, hwnds):
    pid = 23856
    process_id = 0
    thread_id = 0
    if win32gui.IsWindowVisible(hwnd) and win32gui.IsWindowEnabled(hwnd):
        thread_id, process_id  = win32process.GetWindowThreadProcessId(hwnd)

    if process_id == pid:    
        rect = win32gui.GetWindowRect(hwnd)
        x = rect[0]
        y = rect[1]
        w = rect[2] - x
        h = rect[3] - y
        print("Window %s:" % win32gui.GetWindowText(hwnd))
        print("\tLocation: (%d, %d)" % (x, y))
        print("\t    Size: (%d, %d)" % (w, h))
        print("thread_id, process_id", thread_id, process_id)
        hwnds.append(hwnd)

    

    return True

def getWindowInfo():
    
    print("1")

    hwnds = []
    win32gui.EnumWindows(callback, hwnds)
    return hwnds[0] if hwnds else None 


def test_gw():
    #print(gw.getAllTitles())
    print(".......")
    #print(gw.getAllWindows())
    #print(gw.getWindowsWithTitle('Ulysses  v10.1.11 B2804 Sanchez'))
    windowObject = gw.getWindowsWithTitle('Ulysses')
    print(windowObject)

    print("size[0]: ",windowObject[0].size)
    print("size[1]: ",windowObject[1].size)
    #print("topleft: [0].", windowObject[0].topleft)
    #print("topleft: [1].", windowObject[1].topleft)


    print("topleft: [0].", windowObject[0].topleft)
    windowObject[0].moveTo(500,100)
    print("topleft: [0].", windowObject[0].topleft)


def tes_status():
    p = psutil.Process(9708)
    with p.oneshot():
        print(p.name())  # execute internal routine once collecting multiple info
        print(p.cpu_times())  # return cached value
        print(p.cpu_percent())  # return cached value
        print(p.create_time())  # return cached value
        print(p.ppid())  # return cached value
        print(p.status())  # return cached value


tes_status()
#test_gw()
#getWindowInfo()
#testSaveConfiguration()
#testReadConfiguration()