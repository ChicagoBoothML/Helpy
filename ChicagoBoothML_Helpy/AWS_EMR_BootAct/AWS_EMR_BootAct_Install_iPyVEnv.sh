#!/bin/bash

set -x -e

# make Python 2.7 default Python
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python2.7 /usr/bin/python

if grep isMaster /mnt/var/lib/info/instance.json | grep true;
then

# create & enter iPython Virtual Environment
cd /home/hadoop
sudo pip-2.7 install --upgrade VirtualEnv
mkdir iPy
cd iPy
/usr/local/bin/virtualenv -p /usr/bin/python2.7 venv
source venv/bin/activate

# set SPARK_HOME environment variable
export SPARK_HOME="/usr/lib/spark"

# download PostgreSQL JDBC driver
curl https://jdbc.postgresql.org/download/postgresql-9.4-1205.jdbc42.jar --output PostgreSQL_JDBC.jar

# install iPython & other Python packages
pip install --upgrade FindSpark
pip install --upgrade GGPlot
pip install --upgrade Py4J
pip install --upgrade Python-iGraph
pip install --upgrade Sparkit-Learn
pip install --upgrade URLLib3
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
