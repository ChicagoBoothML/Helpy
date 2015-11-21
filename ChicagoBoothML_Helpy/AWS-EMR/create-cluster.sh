#!/bin/sh


# parse command-line options
while getopts "p:s:" opt
do
    case $opt in
        p)
            PRICE=$OPTARG
            ;;
        s)
            S3_BUCKET_NAME=$OPTARG
            ;;
    esac
done


# upload AWS EMR Bootstrap Action script(s) to S3 Bucket
echo "Uploading AWS EMR Bootstrap Action script(s) to s3://$S3_BUCKET_NAME (which must be in region us-west-1)..."
aws s3 cp \
    BootActs/AWS-EMR-BootAct-InstallAnaconda.sh \
    s3://$S3_BUCKET_NAME/AWS-EMR-BootAct-InstallAnaconda.sh \
    --region us-west-1 \
    --no-verify-ssl
echo "done!"


echo "Bidding for AWS EMR cluster with 1 Master, 2 Core & 2 Task nodes at $PRICE / instance / hour..."
aws emr create-cluster \
    --name \
        AWS-EMR-Cluster \
    --release-label \
        emr-4.2.0 \
    --instance-groups \
        InstanceGroupType=MASTER,InstanceCount=1,InstanceType=m1.medium,BidPrice=$PRICE \
        InstanceGroupType=CORE,InstanceCount=2,InstanceType=m1.medium,BidPrice=$PRICE \
        InstanceGroupType=TASK,InstanceCount=2,InstanceType=m1.medium,BidPrice=$PRICE \
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
        Path=s3://$S3_BUCKET_NAME/AWS_EMR_BootAct_InstallAnaconda.sh,Name=InstallAnaconda
echo "Please check your AWS EMR Console for your cluster's status."
