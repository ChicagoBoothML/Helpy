#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# set environment variables
export HOME=/mnt/home

export CUDA_ROOT=/mnt/cuda-7.5
mkdir $CUDA_ROOT

export KERNEL_RELEASE=$(uname -r)
export KERNEL_SOURCE_PATH=/usr/src/kernels/$KERNEL_RELEASE

export TMPDIR=/mnt/tmp
mkdir -p $TMPDIR


# change directory to Temp folder to install NVIDIA driver & CUDA toolkit
cd $TMPDIR

# install NVIDIA driver
# (ref: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using_cluster_computing.html#install-nvidia-driver)
# G2 Instances
# Product Type: GRID
# Product Series: GRID Series
# Product: GRID K520
# Operating System: Linux 64-bit
# Recommended/Beta: Recommended/Certified
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/358.16/NVIDIA-Linux-x86_64-358.16.run
sudo sh NVIDIA-Linux-x86_64-358.16.run --silent --kernel-source-path $KERNEL_SOURCE_PATH --tmpdir $TMPDIR

# install CUDA toolkit
wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run
sudo sh cuda_7.5.18_linux.run --silent --driver --toolkit --toolkitpath $CUDA_ROOT --extract $TMPDIR --kernel-source-path $KERNEL_SOURCE_PATH --tmpdir $TMPDIR
sudo sh cuda-linux64-rel-7.5.18-19867135.run --noprompt --prefix $CUDA_ROOT --tmpdir $TMPDIR
# add CUDA executables & libraries to Path
# instructions: Please make sure that
# -   PATH includes /mnt/cuda-7.5/bin
# -   LD_LIBRARY_PATH includes /mnt/cuda-7.5/lib64, or,
# add /mnt/cuda-7.5/lib64 to /etc/ld.so.conf and run ldconfig as root
export PATH=$PATH:$CUDA_ROOT/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_ROOT/lib:$CUDA_ROOT/lib64
# :/usr/local/cuda/nvvm/libdevice
echo "$CUDA_ROOT/lib"      > ~/cuda.conf
echo "$CUDA_ROOT/lib64"   >> ~/cuda.conf
sudo mv ~/cuda.conf /etc/ld.so.conf.d/
sudo ldconfig
sudo ln -s $CUDA_ROOT/bin/nvcc /usr/bin/nvcc


# change directory back to Home folder
cd ~


# install CUDA-related packages
git clone --recursive http://git.tiker.net/trees/pycuda.git
cd pycuda
sudo python configure.py --cuda-root=$CUDA_ROOT
sudo make install
cd ..
sudo rm -r pycuda

# sudo pip install git+https://github.com/cudamat/cudamat.git   installation fails

sudo pip install --upgrade SciKit-CUDA
sudo pip install GNumPy
sudo pip install --upgrade Hebel
