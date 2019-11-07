
import sys, time
import datetime

class Timer:
    def __init__(self):
        self.time = datetime.datetime.now().time()
        self.date = datetime.datetime.now()
        self.dateTime = format(datetime.datetime.now())


    def setTheTimer(self, arg1, argv2):
        date_time_str = arg1
        #date_time_obj = datetime.datetime.strptime(arg1, '%Y-%m-%d %H:%M:%S.%f')
        date_time_obj = datetime.datetime.strptime(arg1, '%d %m %Y %H:%M:%S')
        self.date = date_time_obj.date()
        self.time = date_time_obj.time()
        self.dateTime = date_time_obj
        print("timer.py: ")
        print(self.date)
        print(self.time.hour)
        print(self.time.minute)

    def waitForTheTime(self):
        currTime = datetime.datetime.now().time()
        if ((currTime.hour == self.time.hour) and (currTime.minute == self.time.minute)):
            print("TIme is done!")



def getTheCurrentTime():
    return str(datetime.datetime.now().time().hour) + " " + str(datetime.datetime.now().time().minute)
