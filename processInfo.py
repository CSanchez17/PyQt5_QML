import random
import time
import sys
import warnings
warnings.simplefilter("ignore", UserWarning)
sys.coinit_flags = 2
from pywinauto import application
from pywinauto.findwindows import WindowAmbiguousError, WindowNotFoundError

#APPS_POOL = ['Notepad', 'Rechner', 'Ulysses']


# Select random app from the pull of apps
def show_rand_app():
    # Init App object
    app = application.Application()

    #random_app = random.choice(APPS_POOL)
    #random_app = APPS_POOL[2]
    
    #print("Select %s" % random_app)
    app.connect(path=r"C:\Ulysses\Client\Ulysses.exe")
    #app.connect(title_re=".*%s.*" % random_app)

    # Access app's window object
    app_dialog = app.top_window_()

    app_dialog.Minimize()
    app_dialog.restore()
    #app_dialog.SetFocus()


def moveWindowToFront():    
    show_rand_app()
    #time.sleep(0.3)