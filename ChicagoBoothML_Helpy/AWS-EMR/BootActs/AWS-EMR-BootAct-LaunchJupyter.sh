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

    # launch Jupyter as "no hang-up" background process
    # ref: http://stackoverflow.com/questions/15595374/whats-the-difference-between-nohup-and-ampersand
    nohup /usr/local/bin/ipython notebook --no-browser > jupyter_notebook.log &
fi
