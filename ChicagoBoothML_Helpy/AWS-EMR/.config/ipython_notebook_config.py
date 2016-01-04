from jupyter_core.paths import jupyter_config_dir, jupyter_data_dir
import os
import sys


sys.path.append(os.path.join(jupyter_data_dir(), 'extensions'))


c = get_config()

c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8133

c.NotebookApp.extra_template_paths = [os.path.join(jupyter_data_dir(), 'templates')]
