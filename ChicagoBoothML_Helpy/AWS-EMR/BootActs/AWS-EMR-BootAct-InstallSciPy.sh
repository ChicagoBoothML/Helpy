#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# install/update SciPy stack, excl. Nose
sudo pip install --upgrade NumPy
sudo pip install --upgrade Pandas
sudo pip install --upgrade SciPy
sudo pip install --upgrade SymPy
# install iPython & MatPlotLib on Master node only
if grep isMaster /mnt/var/lib/info/instance.json | grep true;
then
    sudo pip install --upgrade iPython[all]
    sudo pip install --upgrade MatPlotLib
fi
