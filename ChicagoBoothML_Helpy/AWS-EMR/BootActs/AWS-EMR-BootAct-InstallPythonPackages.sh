#!/bin/bash


set -x -e


# return to Home folder
cd ~


# set SPARK_HOME environment variable
export SPARK_HOME="/usr/lib/spark"


# download PostgreSQL JDBC driver
curl https://jdbc.postgresql.org/download/postgresql-9.4-1205.jdbc42.jar --output PostgreSQL_JDBC.jar


# install dependencies
echo "[fedora]"                                                                               > ~/fedora.repo
echo "name=fedora"                                                                           >> ~/fedora.repo
echo "mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23&arch=\$basearch" >> ~/fedora.repo
echo "enabled=1"                                                                             >> ~/fedora.repo
echo "gpgcheck=0"                                                                            >> ~/fedora.repo
sudo mv ~/fedora.repo /etc/yum.repos.d/

sudo yum install -y gcc
sudo yum install -y gcc-c++
sudo yum install -y gcc-gfortran

sudo yum install -y boost
sudo yum install -y cairo-devel
sudo yum install -y git
sudo yum install -y libjpeg-devel
sudo yum install -y ncurses-devel
sudo yum install -y patch


# install LinuxBrew
git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
export PATH="~/.linuxbrew/bin:~/.linuxbrew/sbin:$PATH:/user/local/include"
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


# install Python packages

# Cython
sudo pip install --upgrade Cython

# complete/updated SciPy stack (excl. Nose)
sudo pip install --upgrade NumPy
sudo pip install --upgrade SciPy
sudo pip install --upgrade MatPlotLib
sudo pip install --upgrade Pandas
sudo pip install --upgrade SymPy
sudo pip install --upgrade "ipython[all]"

# certain popular SkiKits: http://scikits.appspot.com/scikits
sudo pip install --upgrade SciKit-Image
sudo pip install --upgrade SciKit-Learn
sudo pip install --upgrade StatsModels
sudo pip install --upgrade TimeSeries

# advanced visualization tools: Bokeh, GGPlot, GNUPlot, MayaVi & Plotly
sudo pip install --upgrade Bokeh
sudo pip install --upgrade GGPlot
sudo pip install --upgrade GNUPlot-Py --allow-external GNUPlot-Py --allow-unverified GNUPlot-Py

# brew install Expat
# brew install MakeDepend
# brew tap Homebrew/Science
# brew install --python --qt vtk5
# sudo pip install --upgrade MayaVi

sudo pip install --upgrade Plotly

# CUDA/GPU tools, Theano & Deep Learning
# sudo pip install --upgrade PyCUDA
# sudo pip install --upgrade SciKit-CUDA
sudo pip install --upgrade Theano
sudo pip install --upgrade Keras
sudo pip install --upgrade NeuroLab
sudo pip install --upgrade SciKit-NeuralNetwork

# install Geos, Proj, Basemap & other geospatial libraries
git clone https://github.com/matplotlib/basemap.git
cd basemap/geos-*
export GEOS_DIR=/usr/local
./configure --prefix=$GEOS_DIR
make
sudo make install
cd ..
sudo python setup.py install
cd ..
sudo rm -r basemap

wget http://download.osgeo.org/proj/proj-4.8.0.tar.gz
tar xzf proj-4.8.0.tar.gz
sudo rm proj-4.8.0.tar.gz
cd proj-4.8.0
export PROJ_DIR=/usr/local
./configure --prefix=$PROJ_DIR
make
sudo make install
cd ..
sudo rm -r proj-4.8.0

sudo pip install --upgrade Descartes
sudo pip install --upgrade PyProj
sudo pip install --upgrade PySAL

# brew install gdal
# sudo pip install --upgrade Fiona   # depends on GDAL
# sudo pip install --upgrade Cartopy
# sudo pip install --upgrade Kartograph

# network analysis tools: APGL, Graph-Tool, GraphViz, NetworkX, Python-iGraph & SNAPPy
sudo pip install --upgrade APGL

# (we skip installing Graph-Tool because it requires GCC C++ 14 compiler)
# wget https://downloads.skewed.de/graph-tool/graph-tool-2.12.tar.bz2
# tar jxf graph-tool-2.12.tar.bz2
# sudo rm graph-tool-2.12.tar.bz2
# cd graph-tool-*
# ./configure
# make
# sudo make install

sudo pip install --upgrade GraphViz
sudo pip install --upgrade NetworkX
sudo pip install --upgrade Python-iGraph
sudo pip install --upgrade SNAPPy

# FindSpark
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
