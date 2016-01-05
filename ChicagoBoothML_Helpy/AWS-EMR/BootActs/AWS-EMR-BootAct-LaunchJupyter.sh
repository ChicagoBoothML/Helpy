#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# launch Jupyter on Master node only
if grep isMaster /mnt/var/lib/info/instance.json | grep true;
then
    # change Home directory
    export HOME=/mnt/home

    # source script specifying environment variables
    source ~/.EnvVars

    # create iPython profile
    /usr/local/bin/ipython profile create default

    # launch Jupyter
    nohup /usr/local/bin/ipython notebook --no-browser > jupyter_notebook.log &
fi
