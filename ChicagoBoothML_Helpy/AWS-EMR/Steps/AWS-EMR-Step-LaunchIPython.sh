#!/bin/bash

# create iPython profile
ipython profile create default
echo "c = get_config()"                    > /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.ip = '*'"             >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.port = 8133"          >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py

# launch iPython server
nohup ipython notebook --no-browser        > /mnt/var/log/python_notebook.log &
