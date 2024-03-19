# Terraform Script for Data Processing Flow

## What will this script do?
- Create S3 Bucket (`acr-sentiment-bucket-team-7`)
- Create Lambda Function (`acr-lambda-function-team-7`)
- Create Dynamo DB Tables
    - `categories`
    - `products`
    - `reviews`
    - `subscriptions`

## How Data Processing Flow will work?
- When CSV Files containing data will be uploaded to S3 Bucket (`acr-sentiment-bucket-team-7`) Lambda Function will be triggered which will insert data to the DynamoDB Tables

# Steps to Run Terraform Script

## Note: Make sure you are creating all resources in the same region (us-east-1)

## Step 1: Start EC2 to Install Terraform

- Start EC2 with type 't2.micro'
- Connect to EC2

- Install Terraform (Use following Commands):
    - `sudo yum install -y yum-utils`
    - `sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo`
    - `sudo yum -y install terraform`

- Verify Terraform Installation:
    - `terraform -version`

## Step 2: Configure AWS CLI in EC2

- Use Following Command to Configure AWS CLI
    - `aws configure`

- Provide the Access Key Details, Region Name (us-east-1) and Output Format (JSON)

- If you don't have Access Key, create it by using following path: 
    - Click on Your Account Name -> Security credentials -> Access keys -> Create access key 

## Step 3: Upload Terraform Script in S3 Bucket and download in Running EC2

- Create S3 Bucket and Upload Terraform Script and lambda.py File from `dataprocessing` Folder

- Check if AWS CLI is configured correctly by using following command:
    - `aws s3 ls`

- Download Terraform Script in the EC2 using following commands:
    - `aws s3 cp s3://[Your S3 Bucket Name] . --recursive`

## Step 4: Run Terraform

- Use following Command:
    - `terraform init`

- Check Terraform Plan using following Command:
    - `terraform plan`

- Apply Terraform using following CommandL
    - `terraform apply` and then type 'yes'

- All of the Required Services will Spin-Up.

## Step 5: Upload Dataset Files

- Upload the datasets One by One. 
- You can check if Data is being inserted into DynamoDB in CloudWatch.
- Once all Files are uploaded check in DynamoDB if all tables are populated or not.

## Step 6: Destroy Terraform
- You will have to go through all of the process once again if you perform below step.

- Use following command if you want to delete all the resources used for Data Processing.
    - `terraform destroy` and then type 'yes'
