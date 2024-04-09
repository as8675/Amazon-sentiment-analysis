# Terraform Script to Start Application

## What will this script do?
- Create S3 Bucket (e.g. `acr-sentiment-bucket-team-7>`)
- Create Lambda Function (`acr-lambda-function-team-7`)
- Create Dynamo DB Tables
    - `categories`
    - `products`
    - `reviews`
    - `subscriptions`
- Clone the Latest Changes from Git 'main' branch in EC2.
- Install all the required dependencies.
- Assign Elastic IP Address to EC2 Instance and Start the Flask App.
- Elastic IP will then be leveraged in Frontend Application.
- Deploy frontend App on AWS Amplify

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
- Make Necessary Changes in `variable.tf`
    - You will need to provide:
        - Your Key Value Pair
        - GitHub Repository Admin's Username
        - GitHub Repository Admin's PAT
        - Desired AWS Region
        - Your AWS Root Access Key
        - Your AWS Root Secret Access Key
        - You will need to provide unique S3 Bucket Name

- Create S3 Bucket and Upload Terraform Script and lambda.py File.

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

- Flask Application will Start

- Use `http://{Elasti IP}:5000` to access the API Endpoints

## Step 5: Destroy Terraform
- Use following command if you want stop the Application and Delete all resources.
    - `terraform destroy` and then type 'yes'