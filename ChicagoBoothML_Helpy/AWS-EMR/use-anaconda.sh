#!/bin/bash

sudo chmod 777 /usr/lib/spark/conf/spark-env.sh
sudo echo "; export PYSPARK_PYTHON=/Anaconda/bin/python2.7" >> /usr/lib/spark/conf/spark-env.sh
