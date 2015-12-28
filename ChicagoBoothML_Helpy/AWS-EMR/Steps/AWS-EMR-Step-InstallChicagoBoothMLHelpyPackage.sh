#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# change Home directory
export HOME=/mnt/home


# install ChicagoBoothML Helpy package
git clone https://github.com/ChicagoBoothML/Helpy.git
cd Helpy
sudo python setup.py develop
cd ..
