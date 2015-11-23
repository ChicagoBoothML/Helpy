#!/bin/sh

PORT=8133

# parse command-line options
while getopts "d:" opt
do
    case $opt in
        d)
            AWS_EMR_CLUSTER_PUBLIC_DNS=$OPTARG
            ;;
    esac
done

# connect to AWS EMR Cluster's iPython Notebook via a pipe
echo "Please open LOCALHOST:$PORT on your web browser"
ssh -o ServerAliveInterval=10 -i keypair.pem -N -L $PORT:$AWS_EMR_CLUSTER_PUBLIC_DNS:$PORT hadoop@$AWS_EMR_CLUSTER_PUBLIC_DNS
