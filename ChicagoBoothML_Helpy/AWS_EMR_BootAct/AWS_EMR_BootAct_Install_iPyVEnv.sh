#!/bin/bash

set -x -e

# make Python 2.7 default Python
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python2.7 /usr/bin/python

if grep isMaster /mnt/var/lib/info/instance.json | grep true;
then

# set SPARK_HOME environment variable
export SPARK_HOME="/usr/lib/spark"

# create & enter iPython Virtual Environment
cd /home/hadoop
sudo pip-2.7 install --upgrade VirtualEnv
/usr/local/bin/virtualenv -p /usr/bin/python2.7 iPyVEnv
cd iPyVEnv
source bin/activate

# install iPython & other Python packages
pip install --upgrade FindSpark
pip install --upgrade GGPlot
pip install --upgrade Py4J
pip install --upgrade Sparkit-Learn
pip install --upgrade "ipython[all]"

# create iPython profile
ipython profile create default
echo "c = get_config()" > /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.port = 8102" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py

# launch iPython Notebook server
nohup ipython notebook --no-browser > /mnt/var/log/python_notebook.log &

fi
