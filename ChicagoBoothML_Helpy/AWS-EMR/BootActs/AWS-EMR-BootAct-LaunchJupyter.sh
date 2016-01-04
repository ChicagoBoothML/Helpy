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

    # download & override Jupyter Notebook Config file
    curl $GITHUB_REPO_RAW_PATH/.config/$JUPYTER_NOTEBOOK_CONFIG_FILE_NAME --output $JUPYTER_DIR/$JUPYTER_NOTEBOOK_CONFIG_FILE_NAME

    # launch iPython server
    nohup /usr/local/bin/ipython notebook --no-browser > /mnt/var/log/python_notebook.log &
fi
