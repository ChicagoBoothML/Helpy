# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi
# User specific aliases and functions
export MNT_HOME=/mnt/home
mkdir -p $MNT_HOME
cd $MNT_HOME
export SPARK_HOME=/usr/lib/spark
export CUDA_ROOT=/mnt/cuda-7.5
mkdir -p $CUDA_ROOT
export TMPDIR=/mnt/tmp
mkdir -p $TMPDIR
export HOMEBREW_TEMP=$TMPDIR
export KERNEL_RELEASE=$(uname -r)
export KERNEL_SOURCE_PATH=/usr/src/kernels/$KERNEL_RELEASE
export GEOS_DIR=/usr/local
export PROJ_DIR=/usr/local
export IPYTHON_NOTEBOOK_CONFIG_FILE_PATH=$MNT_HOME/.ipython/profile_default/ipython_notebook_config.py