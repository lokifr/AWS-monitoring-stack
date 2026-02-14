#!/bin/bash

# Configuration
REGION="us-east-1"
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
INSTANCE_TYPE="t3.medium"
AMI_ID="ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS in us-east-1 (Change if needed)
KEY_NAME="us-east1"
TAG_PREFIX="Prometheus-Monitoring"

echo "Starting deployment in $REGION..."

# 1. Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$TAG_PREFIX-VPC --region $REGION
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames "{\"Value\":true}" --region $REGION
echo "VPC ID: $VPC_ID"

# 2. Create Internet Gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=$TAG_PREFIX-IGW --region $REGION
echo "IGW ID: $IGW_ID"

# 3. Create Subnet
echo "Creating Public Subnet..."
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --availability-zone ${REGION}a --region $REGION --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$TAG_PREFIX-Subnet --region $REGION
echo "Subnet ID: $SUBNET_ID"

# 4. Create Route Table
echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION > /dev/null
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID --region $REGION
aws ec2 create-tags --resources $ROUTE_TABLE_ID --tags Key=Name,Value=$TAG_PREFIX-RT --region $REGION
echo "Route Table ID: $ROUTE_TABLE_ID"

# 5. Create Security Group
echo "Creating Security Group..."
SG_ID=$(aws ec2 create-security-group --group-name PrometheusSG --description "Allow SSH and Prometheus" --vpc-id $VPC_ID --region $REGION --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 9090 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 3000 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 9093 --cidr 0.0.0.0/0 --region $REGION
aws ec2 create-tags --resources $SG_ID --tags Key=Name,Value=$TAG_PREFIX-SG --region $REGION
echo "Security Group ID: $SG_ID"

# 6. Ensure Key Pair
if ! aws ec2 describe-key-pairs --key-names $KEY_NAME --region $REGION >/dev/null 2>&1; then
    echo "Creating Key Pair $KEY_NAME..."
    aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text --region $REGION > ${KEY_NAME}.pem
    chmod 400 ${KEY_NAME}.pem
    echo "Key pair created: ${KEY_NAME}.pem"
else
    echo "Key pair $KEY_NAME already exists."
fi

# 7. Launch Instance
echo "Launching EC2 Instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SG_ID \
    --subnet-id $SUBNET_ID \
    --associate-public-ip-address \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":50,\"VolumeType\":\"gp3\"}}]" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_PREFIX-Instance}]" \
    --region $REGION \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Instance launching: $INSTANCE_ID"
echo "Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text --region $REGION)

echo "--------------------------------------------------"
echo "Deployment Complete!"
echo "Instance ID: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
echo "SSH Command: ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP"
echo "--------------------------------------------------"
