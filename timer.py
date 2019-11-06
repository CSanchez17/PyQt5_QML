
import sys, time
import datetime

def setTheTimer(arg1, argv2):
    date_time_str = arg1
    #date_time_obj = datetime.datetime.strptime(arg1, '%Y-%m-%d %H:%M:%S.%f')
    date_time_obj = datetime.datetime.strptime(arg1, '%d %m %Y %H %M %S%f')
    print("timer.py: ")
    print(date_time_obj)