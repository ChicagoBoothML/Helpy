#!/bin/sh


# parse command-line options
while getopts "s:w:t:p:" opt
do
    case $opt in
        s)
            S3_BUCKET_NAME=$OPTARG
            ;;
        w)
            NB_WORKER_NODES=$OPTARG
            ;;
        t)
            INSTANCE_TYPE=$OPTARG
            ;;
        p)
            PRICE=$OPTARG
            ;;
    esac
done


# upload AWS EMR Bootstrap Action script(s) to S3 Bucket
echo "Uploading AWS EMR Bootstrap Action script(s) to s3://$S3_BUCKET_NAME (which must be in region us-west-1)..."
aws s3 cp \
    BootActs/AWS-EMR-BootAct-InstallPythonPackages.sh \
    s3://$S3_BUCKET_NAME/AWS-EMR-BootAct-InstallPythonPackages.sh \
    --region us-west-1 \
    --no-verify-ssl
echo "done!"


echo "Bidding for AWS EMR cluster with 1 Master + $NB_WORKER_NODES Core nodes at $PRICE / instance / hour..."
aws emr create-cluster \
    --name \
        "1+$NB_WORKER_NODES x $INSTANCE_TYPE @ $PRICE/inst/hr" \
    --release-label \
        emr-4.2.0 \
    --instance-groups \
        InstanceGroupType=MASTER,InstanceCount=1,InstanceType=$INSTANCE_TYPE,BidPrice=$PRICE \
        InstanceGroupType=CORE,InstanceCount=$NB_WORKER_NODES,InstanceType=$INSTANCE_TYPE,BidPrice=$PRICE \
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
