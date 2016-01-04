#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# change Home directory
export HOME=/mnt/home


# source script specifying environment variables
source ~/.EnvVars


# change directory to Programs directory
cd $PROGRAMS_DIR


# install/update SciPy stack, excl. Nose
sudo pip install --upgrade NumPy
sudo pip install --upgrade Pandas
sudo pip install --upgrade SciPy
sudo pip install --upgrade SymPy

# install iPython / Jupyter (plus extensions) & MatPlotLib on Master node only
if grep isMaster /mnt/var/lib/info/instance.json | grep true;
then
    sudo pip install --upgrade iPython[all]
    sudo pip install --upgrade Jupyter[all]
    sudo pip install --upgrade iPyExt

    git clone https://github.com/ipython-contrib/IPython-notebook-extensions
    cd IPython-notebook-extensions
    python setup.py install
    cd $PROGRAMS_DIR

    sudo pip install --upgrade MatPlotLib
fi
