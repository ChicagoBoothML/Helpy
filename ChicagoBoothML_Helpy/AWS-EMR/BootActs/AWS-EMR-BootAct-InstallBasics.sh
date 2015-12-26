#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# set CONSTANTS
export GITHUB_REPO_RAW_PATH=https://raw.githubusercontent.com/ChicagoBoothML/Helpy/master/ChicagoBoothML_Helpy/AWS-EMR


# install DOS2UNIX utility
sudo yum install -y dos2unix


# download & source script specifying environment variables in Home directory
cd ~
wget $GITHUB_REPO_RAW_PATH/.EnvVars
dos2unix .EnvVars
source .EnvVars


# change directory to MNT_HOME
cd $MNT_HOME


# enable installation from Fedora repo
echo "[fedora]"                                                                               > fedora.repo
echo "name=fedora"                                                                           >> fedora.repo
echo "mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23&arch=\$basearch" >> fedora.repo
echo "enabled=0"                                                                             >> fedora.repo
echo "gpgcheck=0"                                                                            >> fedora.repo
sudo mv fedora.repo /etc/yum.repos.d/


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
