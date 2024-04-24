# Terraform Script to Start Application

## What will this script do?
- Create S3 Bucket (e.g. `acr-sentiment-bucket-team-7`)
- Create Lambda Function (`acr-lambda-function-team-7`)
- Create Dynamo DB Tables
    - `categories`
    - `products`
    - `reviews`
    - `subscriptions`
- Log the data processing results in CloudWatch.
- Create an EC2 instance
    - Clone the Latest Changes from Git 'main' branch in EC2.
    - Install all the required dependencies.
    - Assign Elastic IP Address to EC2 Instance and Start the Flask App.
- Create a frontend App on AWS Amplify and use Elastic IP to hit backend Endpoints.
- Use Amazon Cognito for user authentication.
- Use Amazon Comprehend to get sentiments.

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

- Create S3 Bucket (Name it as per your choice) and Upload Terraform Script and lambda.py File.
    - This bucket will be used to download all the required files to spin up all the required services.
    - You will need to upload following files:
        - `variable.tf`
        - `data.tf`
        - `main.tf`
        - `output.tf`
        - `lambda.py`

- Check if AWS CLI is configured correctly by using following command:
    - `aws s3 ls`

- Download Terraform Script in the EC2 using following commands:
    - `aws s3 cp s3://[S3 Bucket Name which has TF Files] . --recursive`

## Step 4: Run Terraform

- Use following Command:
    - `terraform init`

- Check Terraform Plan using following Command:
    - `terraform plan`

- Apply Terraform using following CommandL
    - `terraform apply` and then type 'yes'

## Step 5: Upload Data and Setup Amplify

- Upload the provided dataset files to `acr-sentiment-bucket-team-7-*` 
- Check if `categories`,  `products`, `reviews` tables in DynamoDB are populated or not.
- Go to Amplify and 'Run Build' (It usually takes 3-4 minutes to complete.)
- Open the Amplify Link once code is deployed.
- You will need to **Allow Insecure Content** to access the API Endpoints (As we are accessing HTTP endpoints from website hosted using HTTPS).
    - Click on **View site information** near the left side of the link.
    - Go to **Site settings** and Allow Insecure Content.
- Reload the page once and you can start using the Application.

## Step 6: Destroy Terraform
- Use following command if you want stop the Application and Delete all resources.
    - `terraform destroy` and then type 'yes'