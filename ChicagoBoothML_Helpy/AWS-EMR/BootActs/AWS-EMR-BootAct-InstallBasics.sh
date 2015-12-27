#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# set CONSTANTS
export HOME=/mnt/home
export GITHUB_REPO_RAW_PATH=https://raw.githubusercontent.com/ChicagoBoothML/Helpy/master/ChicagoBoothML_Helpy/AWS-EMR


# change directory to new Home
mkdir -p ~
cd ~


# install DOS2UNIX utility
sudo yum install -y dos2unix


# download & source script specifying environment variables in Home directory
wget $GITHUB_REPO_RAW_PATH/.EnvVars
dos2unix .EnvVars
source .EnvVars


# download additional Yum Repo specs files
cd /etc/yum.repos.d
sudo wget $GITHUB_REPO_RAW_PATH/YumRepos/fedora.repo
sudo wget $GITHUB_REPO_RAW_PATH/YumRepos/google-chrome.repo
sudo rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub
cd ~


# update existing Yum packages
sudo yum update -y


# install essential Development Tools
sudo yum groupinstall -y "Development tools"


# re-install compatible kernel source files
sudo yum erase -y kernel-devel
sudo yum install -y kernel-devel-$KERNEL_RELEASE


# install C, C++ & ForTran compilers
sudo yum install -y gcc
sudo yum install -y gcc-c++
sudo yum install -y gcc-gfortran


# install numerical libraries
sudo yum install -y atlas-devel
sudo yum install -y blas-devel
sudo yum install -y lapack-devel


# install Boost
sudo yum install -y boost


# install CMake
sudo yum install -y cmake


# install Git
sudo yum install -y git


# install HDF5
sudo rpm -ivh http://www.hdfgroup.org/ftp/HDF5/current/bin/RPMS/hdf5-1.8.16-1.with.szip.encoder.el7.x86_64.rpm
sudo rpm -ivh http://www.hdfgroup.org/ftp/HDF5/current/bin/RPMS/hdf5-devel-1.8.16-1.with.szip.encoder.el7.x86_64.rpm


# install some other packages
sudo yum install -y cairo-devel
sudo yum install -y libjpeg-devel
sudo yum install -y ncurses-devel
sudo yum install -y patch


# install EPLL Release package
# ref: https://lambda-linux.io
curl -X GET -o RPM-GPG-KEY-lambda-epll https://lambda-linux.io/RPM-GPG-KEY-lambda-epll
sudo rpm --import RPM-GPG-KEY-lambda-epll
curl -X GET -o epll-release-2015.09-1.1.ll1.noarch.rpm https://lambda-linux.io/epll-release-2015.09-1.1.ll1.noarch.rpm
sudo yum install -y epll-release-2015.09-1.1.ll1.noarch.rpm
sudo rm RPM-GPG-KEY-lambda-epll
sudo rm epll-release-2015.09-1.1.ll1.noarch.rpm


# install Firefox
# ref: https://lambda-linux.io/blog/2015/01/28/announcing-firefox-browser-support-for-amazon-linux
wget -O firefox-latest.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
bzcat firefox-latest.tar.bz2 | tar xvf -
sudo rm firefox-latest.tar.bz2


# install LinuxBrew
git clone https://github.com/Homebrew/linuxbrew.git $LINUXBREW_HOME
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


# install basic Python packages

# Cython
sudo pip install --upgrade Cython

# FindSpark
sudo pip install --upgrade FindSpark

# Py4J (for PySpark)
sudo pip install --upgrade Py4J

# PySpark_CSV
wget https://raw.githubusercontent.com/seahboonsiew/pyspark-csv/master/pyspark_csv.py
