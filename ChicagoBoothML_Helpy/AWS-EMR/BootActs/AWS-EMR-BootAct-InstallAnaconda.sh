#!/bin/bash


set -x -e


# *** BOOTSTRAP MASTER NODE ONLY ***
if grep isMaster /mnt/var/lib/info/instance.json | grep true;
then


# set SPARK_HOME environment variable
export SPARK_HOME="/usr/lib/spark"


# download PostgreSQL JDBC driver
curl https://jdbc.postgresql.org/download/postgresql-9.4-1205.jdbc42.jar --output PostgreSQL_JDBC.jar


# install packages by yum
sudo yum -y install gcc
sudo yum -y install gcc-c++
sudo yum -y install gcc-gfortran
sudo yum -y install git


# install LinuxBrew
git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
export PATH="~/.linuxbrew/bin:~/.linuxbrew/sbin:$PATH"
export HOMEBREW_TEMP=/var/tmp
sudo chmod +t /var/tmp
sudo ln -s $(which gcc) `brew --prefix`/bin/gcc-$(gcc -dumpversion |cut -d. -f1,2)
sudo ln -s $(which g++) `brew --prefix`/bin/g++-$(g++ -dumpversion |cut -d. -f1,2)
sudo ln -s $(which gfortran) `brew --prefix`/bin/gfortran-$(gfortran -dumpversion |cut -d. -f1,2)


# download Anaconda installer
curl http://repo.Continuum.io/archive/Anaconda2-2.4.0-Linux-x86_64.sh --output InstallAnaconda.sh

# install Anaconda into /Anaconda directory, without user input, and skip installation if it has already been installed
sudo bash InstallAnaconda.sh -b -f -p /Anaconda

# make Anaconda Python 2.7 default Python
sudo rm /usr/bin/python
sudo rm /usr/bin/pip
sudo ln -s /Anaconda/bin/python2.7 /usr/bin/python
sudo ln -s /Anaconda/bin/conda /usr/bin/conda
sudo ln -s /Anaconda/bin/pip /usr/bin/pip
sudo ln -s /Anaconda/bin/ipython /usr/bin/ipython

# install Python packages
sudo pip install --upgrade FindSpark

# create iPython profile
ipython profile create default
echo "c = get_config()" > /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.ip = '*'" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
echo "c.NotebookApp.port = 8102" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py

# launch iPython Notebook server
nohup ipython notebook --no-browser > /mnt/var/log/python_notebook.log &


fi
