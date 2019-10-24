import random
import time
import sys
import warnings
warnings.simplefilter("ignore", UserWarning)
sys.coinit_flags = 2
from pywinauto import application
from pywinauto.findwindows import WindowAmbiguousError, WindowNotFoundError


# Select random app from the pull of apps
def show_rand_app_v2():
   # APPS_POOL = ['Ulysses (32 Bit)']
    APPS_POOL = ['Ulysses v10.1.7 B2804 Sanchez']
    # Init App object
    app = application.Application()

    random_app = random.choice(APPS_POOL)
    try:
        print('Select "%s"' % random_app)
        app.connect(title_re=".*%s.*" % random_app)

        # Access app's window object
        app_dialog = app.top_window_()

        app_dialog.Minimize()
        app_dialog.Restore()
        #app_dialog.SetFocus()
    except(WindowNotFoundError):
        print('"%s" not found' % random_app)
        pass
    except(WindowAmbiguousError):
        print('There are too many "%s" windows found' % random_app)
        pass


# Select the PID window and bring it to the top
def moveWindowToFront(arg1):    
    pid = int(arg1)
    app = application.Application().connect(process=pid)
    dlg = app.top_window().set_focus()
    #print(dlg)
