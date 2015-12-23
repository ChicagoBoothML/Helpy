#!/bin/sh


# parse command-line options
while getopts "b:n:t:m:w:" opt
do
    case $opt in
        b)
            S3_BUCKET_NAME=$OPTARG
            ;;
        n)
            NB_WORKER_NODES=$OPTARG
            ;;
        t)
            WORKER_INSTANCE_TYPE=$OPTARG
            ;;
        m)
            MASTER_INSTANCE_PRICE=$OPTARG
            ;;
        w)
            WORKER_INSTANCE_PRICE=$OPTARG
            ;;
    esac
done


# other parameters
MASTER_INSTANCE_TYPE=g2.2xlarge


# upload AWS EMR Bootstrap Action script(s) to S3 Bucket
echo "Uploading AWS EMR Bootstrap Action script(s) to s3://$S3_BUCKET_NAME (which must be in region us-west-1)..."
aws s3 cp \
    BootActs/AWS-EMR-BootAct-InstallPythonPackages.sh \
    s3://$S3_BUCKET_NAME/AWS-EMR-BootAct-InstallPythonPackages.sh \
    --region us-west-1 \
    --no-verify-ssl
echo "done!"


echo "Bidding for AWS EMR cluster with 1 x $MASTER_INSTANCE_TYPE Master @ \$$MASTER_INSTANCE_PRICE/node/hr + $NB_WORKER_NODES x $WORKER_INSTANCE_TYPE Core Workers @ \$$WORKER_INSTANCE_PRICE/node/hr..."
aws emr create-cluster \
    --name \
        "1 x $MASTER_INSTANCE_TYPE Master @ \$$MASTER_INSTANCE_PRICE/node/hr + $NB_WORKER_NODES x $WORKER_INSTANCE_TYPE Core Workers @ \$$WORKER_INSTANCE_PRICE/node/hr" \
    --release-label \
        emr-4.2.0 \
    --instance-groups \
        InstanceGroupType=MASTER,InstanceCount=1,InstanceType=$MASTER_INSTANCE_TYPE,BidPrice=$MASTER_INSTANCE_PRICE \
        InstanceGroupType=CORE,InstanceCount=$NB_WORKER_NODES,InstanceType=$WORKER_INSTANCE_TYPE,BidPrice=$WORKER_INSTANCE_PRICE \
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
        Name=Spark \
    --bootstrap-actions \
        Path=s3://$S3_BUCKET_NAME/AWS-EMR-BootAct-InstallPythonPackages.sh,Name=InstallPythonPackages
echo "Please check your AWS EMR Console for your cluster's status."
