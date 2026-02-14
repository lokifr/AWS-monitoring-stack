#!/bin/bash

# Configuration
REGION="us-east-1"
KEY_NAME="us-east1"
TAG_PREFIX="Prometheus-Monitoring"

echo "Starting cleanup in $REGION..."

# 1. DELETE INSTANCES (Find by Security Group)
# We find the SG first, then any instance using it.
echo "Finding Security Group..."
SG_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=$TAG_PREFIX-SG" --query 'SecurityGroups[0].GroupId' --output text --region $REGION)

if [ "$SG_ID" != "None" ] && [ -n "$SG_ID" ]; then
    echo "Found Security Group: $SG_ID. Checking for instances..."
    # Find all instances using this SG, regardless of Name tag or state (except terminated)
    INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=instance.group-id,Values=$SG_ID" --query 'Reservations[].Instances[].InstanceId' --output text --region $REGION)

    if [ -n "$INSTANCE_IDS" ]; then
        echo "Terminating Instances using this SG: $INSTANCE_IDS"
        aws ec2 terminate-instances --instance-ids $INSTANCE_IDS --region $REGION
        echo "Waiting for instances to terminate..."
        aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS --region $REGION
    else
        echo "No active instances found using the SG."
    fi
else
    echo "Security Group not found (or already deleted)."
fi

# 2. Delete Key Pair
if aws ec2 describe-key-pairs --key-names $KEY_NAME --region $REGION >/dev/null 2>&1; then
    echo "Deleting Key Pair $KEY_NAME..."
    aws ec2 delete-key-pair --key-name $KEY_NAME --region $REGION
    rm -f ${KEY_NAME}.pem
else
    echo "Key pair not found."
fi

# 3. Delete Security Group (Now safe)
if [ "$SG_ID" != "None" ] && [ -n "$SG_ID" ]; then
    echo "Deleting Security Group: $SG_ID"
    aws ec2 delete-security-group --group-id $SG_ID --region $REGION
fi

# 4. Delete Subnet
SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$TAG_PREFIX-Subnet" --query 'Subnets[0].SubnetId' --output text --region $REGION)
if [ "$SUBNET_ID" != "None" ] && [ -n "$SUBNET_ID" ]; then
    echo "Deleting Subnet: $SUBNET_ID"
    aws ec2 delete-subnet --subnet-id $SUBNET_ID --region $REGION
else
    echo "Subnet not found."
fi

# 5. Delete Route Table
RT_ID=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$TAG_PREFIX-RT" --query 'RouteTables[0].RouteTableId' --output text --region $REGION)
if [ "$RT_ID" != "None" ] && [ -n "$RT_ID" ]; then
    echo "Deleting Route Table: $RT_ID"
    aws ec2 delete-route-table --route-table-id $RT_ID --region $REGION
else
    echo "Route Table not found."
fi

# 6. Delete Internet Gateway
IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values=$TAG_PREFIX-IGW" --query 'InternetGateways[0].InternetGatewayId' --output text --region $REGION)
if [ "$IGW_ID" != "None" ] && [ -n "$IGW_ID" ]; then
    echo "Detaching and Deleting IGW: $IGW_ID"
    VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$TAG_PREFIX-VPC" --query 'Vpcs[0].VpcId' --output text --region $REGION)
    if [ "$VPC_ID" != "None" ] && [ -n "$VPC_ID" ]; then
        aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
    fi
    aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region $REGION
else
    echo "Internet Gateway not found."
fi

# 7. Delete VPC
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$TAG_PREFIX-VPC" --query 'Vpcs[0].VpcId' --output text --region $REGION)
if [ "$VPC_ID" != "None" ] && [ -n "$VPC_ID" ]; then
    echo "Deleting VPC: $VPC_ID"
    aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION
else
    echo "VPC not found."
fi

echo "Cleanup Complete!"
