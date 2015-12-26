#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# launch iPython on Master node only
if grep isMaster /mnt/var/lib/info/instance.json | grep true;
then
    # source script specifying environment variables
    source ~/.EnvVars

    # create iPython profile
    /usr/local/bin/ipython profile create default
    echo "c = get_config()"                    > $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH
    echo "c.NotebookApp.ip = '*'"             >> $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH
    echo "c.NotebookApp.open_browser = False" >> $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH
    echo "c.NotebookApp.port = 8133"          >> $IPYTHON_NOTEBOOK_CONFIG_FILE_PATH

    # launch iPython server
    nohup /usr/local/bin/ipython notebook --no-browser > /mnt/var/log/python_notebook.log &
fi
