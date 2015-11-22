#!/bin/sh


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
ssh -o ServerAliveInterval=10 -i keypair.pem -N -L 8133:$AWS_EMR_CLUSTER_PUBLIC_DNS:8133 hadoop@$AWS_EMR_CLUSTER_PUBLIC_DNS
