#!/bin/bash


set -x -e


# return to Home folder
cd ~


# set SPARK_HOME environment variable
export SPARK_HOME="/usr/lib/spark"


# download PostgreSQL JDBC driver
curl https://jdbc.postgresql.org/download/postgresql-9.4-1205.jdbc42.jar --output PostgreSQL_JDBC.jar


# install packages by yum
sudo yum -y install gcc
sudo yum -y install gcc-c++
sudo yum -y install gcc-gfortran
sudo yum -y install git
sudo yum -y install ncurses-devel
sudo yum -y install patch


# install LinuxBrew
git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
export PATH="~/.linuxbrew/bin:~/.linuxbrew/sbin:$PATH"
export HOMEBREW_TEMP=/var/tmp
sudo chmod +t /var/tmp
sudo ln -s $(which gcc) `brew --prefix`/bin/gcc-$(gcc -dumpversion |cut -d. -f1,2)
sudo ln -s $(which g++) `brew --prefix`/bin/g++-$(g++ -dumpversion |cut -d. -f1,2)
sudo ln -s $(which gfortran) `brew --prefix`/bin/gfortran-$(gfortran -dumpversion |cut -d. -f1,2)


# make Python 2.7 default Python
sudo rm /usr/bin/python
sudo rm /usr/bin/pip
sudo ln -s /usr/bin/python2.7 /usr/bin/python
sudo ln -s /usr/bin/pip-2.7 /usr/bin/pip


# install Python 2.7 packages

# install complete/updated SciPy stack (excl. Nose)
sudo pip install --upgrade NumPy
sudo pip install --upgrade SciPy
sudo pip install --upgrade MatPlotLib
sudo pip install --upgrade Pandas
sudo pip install --upgrade SymPy
sudo pip install --upgrade "ipython[all]"

# install SkiKit-Learn
sudo pip install --upgrade SciKit-Learn

# install GGPlot
sudo pip install --upgrade GGPlot

# install Theano
sudo pip install --upgrade Theano

# install Geos & Basemap
git clone https://github.com/matplotlib/basemap.git
cd basemap/geos-*
./configure --prefix=/usr/local
make
sudo make install
cd ..
sudo python setup.py install
cd ..
sudo rm -r basemap

# Install Cairo & iGraph
sudo yum -y install cairo-devel
sudo pip install --upgrade Python-iGraph


# install FindSpark
sudo pip install --upgrade FindSpark


# launch iPython from Master node
if grep isMaster /mnt/var/lib/info/instance.json | grep true
then
    # create iPython profile
    /usr/local/bin/ipython profile create default
    echo "c = get_config()"                    > /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
    echo "c.NotebookApp.ip = '*'"             >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
    echo "c.NotebookApp.open_browser = False" >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py
    echo "c.NotebookApp.port = 8133"          >> /home/hadoop/.ipython/profile_default/ipython_notebook_config.py

    # launch iPython server
    nohup /usr/local/bin/ipython notebook --no-browser > /mnt/var/log/python_notebook.log &
fi
