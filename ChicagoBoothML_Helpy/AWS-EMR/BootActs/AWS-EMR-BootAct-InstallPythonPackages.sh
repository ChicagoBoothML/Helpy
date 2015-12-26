#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# replace .BashRC with new file & source it
rm .bashrc
wget https://raw.githubusercontent.com/ChicagoBoothML/Helpy/master/ChicagoBoothML_Helpy/AWS-EMR/.bashrc
source .bashrc


# enable installation from Fedora repo
echo "[fedora]"                                                                               > fedora.repo
echo "name=fedora"                                                                           >> fedora.repo
echo "mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23&arch=\$basearch" >> fedora.repo
echo "enabled=0"                                                                             >> fedora.repo
echo "gpgcheck=0"                                                                            >> fedora.repo
sudo mv fedora.repo /etc/yum.repos.d/


# update all packages
sudo yum update -y
# which covers the following essentials
# sudo yum install -y gcc
# sudo yum install -y gcc-c++
# sudo yum install -y gcc-gfortran
# sudo yum install -y patch

# install essential Development Tools
sudo yum groupinstall -y "Development tools"
# which covers the following essentials:
# sudo yum install -y git

# reinstall some compatible kernel source files
sudo yum erase -y kernel-devel
sudo yum install -y kernel-devel-$KERNEL_RELEASE
# sudo yum install -y kernel-headers-$KERNEL_RELEASE

# experimental installations of Fedora packages:
# cd /etc/yum.repos.d
# sudo wget http://linuxsoft.cern.ch/cern/scl/slc6-scl.repo
# sudo yum -y --nogpgcheck install devtoolset-3-gcc
# sudo yum -y --nogpgcheck install devtoolset-3-gcc-c++

# install numerical libraries
# sudo yum -y install atlas-devel
# sudo yum -y install blas-devel
# sudo yum -y install lapack-devel

# install Boost
sudo yum install -y boost

# install HDF5
sudo rpm -ivh http://www.hdfgroup.org/ftp/HDF5/current/bin/RPMS/hdf5-1.8.16-1.with.szip.encoder.el7.x86_64.rpm
sudo rpm -ivh http://www.hdfgroup.org/ftp/HDF5/current/bin/RPMS/hdf5-devel-1.8.16-1.with.szip.encoder.el7.x86_64.rpm

# install certain other packages
sudo yum install -y cairo-devel
sudo yum install -y libjpeg-devel
# sudo yum install -y ncurses-devel


# install LinuxBrew
git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
export PATH=~/.linuxbrew/bin:~/.linuxbrew/sbin:$PATH:/user/local/include
sudo ln -s $(which gcc) `brew --prefix`/bin/gcc-$(gcc -dumpversion |cut -d. -f1,2)
sudo ln -s $(which g++) `brew --prefix`/bin/g++-$(g++ -dumpversion |cut -d. -f1,2)
sudo ln -s $(which gfortran) `brew --prefix`/bin/gfortran-$(gfortran -dumpversion |cut -d. -f1,2)


# download PostgreSQL JDBC driver
curl https://jdbc.postgresql.org/download/postgresql-9.4-1205.jdbc42.jar --output PostgreSQL_JDBC.jar


# make Python 2.7 default Python
sudo rm /usr/bin/python
sudo rm /usr/bin/pip
sudo ln -s /usr/bin/python2.7 /usr/bin/python
sudo ln -s /usr/bin/pip-2.7 /usr/bin/pip


# install Python packages

# Py4J for Spark
sudo pip install --upgrade Py4J

# Cython
sudo pip install --upgrade Cython

# complete/updated SciPy stack (excl. Nose)
sudo pip install --upgrade iPython[all]
sudo pip install --upgrade MatPlotLib
sudo pip install --upgrade NumPy
sudo pip install --upgrade Pandas
sudo pip install --upgrade SciPy
sudo pip install --upgrade SymPy

# certain popular SkiKits: http://scikits.appspot.com/scikits
sudo pip install --upgrade SciKit-Image
sudo pip install --upgrade SciKit-Learn
sudo pip install --upgrade StatsModels
sudo pip install --upgrade TimeSeries

# Natural Language Toolkit
sudo pip install --upgrade NLTK

# advanced visualization tools: Bokeh, GGPlot, GNUPlot, MayaVi & Plotly
sudo pip install --upgrade Bokeh
sudo pip install --upgrade GGPlot
# sudo pip install --upgrade GNUPlot-Py --allow-external GNUPlot-Py --allow-unverified GNUPlot-Py   skip: cannot find

# brew install Expat
# brew install MakeDepend
# brew tap Homebrew/Science
# brew install --python --qt vtk5
# sudo pip install --upgrade MayaVi

sudo pip install --upgrade Plotly

# Machine Learning packages
sudo pip install --upgrade H2O
sudo pip install --upgrade Orange
sudo pip install --upgrade SKLearn-Pandas
sudo pip install --upgrade Sparkit-Learn

# Geos, Proj, Basemap, Google Maps API & other geospatial libraries
git clone https://github.com/matplotlib/basemap.git
cd basemap/geos-*
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
./configure --prefix=$PROJ_DIR
make
sudo make install
cd ..
sudo rm -r proj-4.8.0

sudo pip install --upgrade Descartes
sudo pip install --upgrade Google-API-Python-Client
sudo pip install --upgrade GoogleMaps
sudo pip install --upgrade PyProj
sudo pip install --upgrade PySAL

# brew install gdal
# sudo pip install --upgrade Fiona   # depends on GDAL
# sudo pip install --upgrade Cartopy   # canno detect Proj4.8
# sudo pip install --upgrade Kartograph    # not yet released

# network analysis tools: APGL, Cairo, Graph-Tool, GraphViz, NetworkX, Python-iGraph & SNAPPy
sudo pip install --upgrade APGL

# (we skip installing Graph-Tool because it requires GCC C++ 14 compiler)
# wget https://downloads.skewed.de/graph-tool/graph-tool-2.12.tar.bz2
# tar jxf graph-tool-2.12.tar.bz2
# sudo rm graph-tool-2.12.tar.bz2
# cd graph-tool-*
# ./configure
# make
# sudo make install

wget http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2
tar jxf py2cairo-1.10.0.tar.bz2
sudo rm -r py2cairo-1.10.0.tar.bz2
cd py2cairo-1.10.0
./waf configure
./waf build
sudo ./waf install
cd ..
sudo rm -r py2cairo-1.10.0

sudo pip install --upgrade GraphViz
sudo pip install --upgrade NetworkX
sudo pip install --upgrade Python-iGraph
sudo pip install --upgrade SNAPPy

# FindSpark
sudo pip install --upgrade FindSpark

# PySpark_CSV
wget https://raw.githubusercontent.com/seahboonsiew/pyspark-csv/master/pyspark_csv.py


# launch iPython from Master node
if grep isMaster /mnt/var/lib/info/instance.json | grep true
then
    # create iPython profile
    /usr/local/bin/ipython profile create default
    echo "c = get_config()"                    > $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH
    echo "c.NotebookApp.ip = '*'"             >> $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH
    echo "c.NotebookApp.open_browser = False" >> $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH
    echo "c.NotebookApp.port = 8133"          >> $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH

    # launch iPython server
    nohup /usr/local/bin/ipython notebook --no-browser > /mnt/var/log/python_notebook.log &
fi
