#!/bin/sh


# parse -s option to get S3 Bucket Name to which to upload the Bootstrap Action script(s)
getopts s: OPTION


# upload Bootstrap Action script(s) to S3 bucket
aws s3 cp \
    BootActs/AWS-EMR-BootAct-InstallAnaconda.sh \
    s3://$OPTARG/AWS-EMR-BootAct-InstallAnaconda.sh \
    --region us-west-1 \
    --no-verify-ssl


# bid for basic AWS EMR cluster with 1 Master, 2 Core & 2 Task nodes
# at cheapest price ($0.001 / instance / hour)
aws emr create-cluster \
    --name \
        AWS-EMR-Cluster \
    --release-label \
        emr-4.2.0 \
    --instance-groups \
        InstanceGroupType=MASTER,InstanceCount=1,InstanceType=m1.medium,BidPrice=0.001 \
        InstanceGroupType=CORE,InstanceCount=2,InstanceType=m1.medium,BidPrice=0.001 \
        InstanceGroupType=TASK,InstanceCount=2,InstanceType=m1.medium,BidPrice=0.001 \
    --no-auto-terminate \
    --use-default-roles \
    --log-uri \
        s3://mbalearnstocode-spark/zzzLogs \
    --ec2-attributes \
        AvailabilityZone=us-west-1a,KeyName=keypair \
    --no-termination-protected \
    --visible-to-all-users \
    --enable-debugging \
    --applications \
        Name=Ganglia \
        Name=Hive \
        Name=Hue \
        Name=Mahout \
        Name=Pig \
        Name=Spark \
    --bootstrap-actions \
        Path=s3://$OPTARG/AWS_EMR_BootAct_InstallAnaconda.sh,Name=InstallAnaconda


# connect to AWS EMR Cluster's iPython Notebook via a pipe
# ssh -o ServerAliveInterval=10 -i keypair.pem -N -L 8102:<Cluster Public DNS>:8102 hadoop@<Cluster Public DNS>
