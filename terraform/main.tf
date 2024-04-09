# Provider
provider "aws" {
    region = var.aws_region
}

# To Create S3 Bucket
resource "aws_s3_bucket" "acr_bucket" {
    bucket = var.s3_bucket
    force_destroy = true
}

# To Create DynamoDB Tables

# 'categories' Table
resource "aws_dynamodb_table" "dynamodb_categories" {
    name = var.dynamodb_categories_table
    billing_mode = "PAY_PER_REQUEST"
    hash_key = var.dynamodb_categories_table_key

    attribute {
        name = var.dynamodb_categories_table_key
        type = "S"
    }
}

# 'products' Table
resource "aws_dynamodb_table" "dynamodb_products" {
    name = var.dynamodb_products_table
    billing_mode = "PAY_PER_REQUEST"
    hash_key = var.dynamodb_products_table_key

    attribute {
        name = var.dynamodb_products_table_key
        type = "S"
    }
}

# 'reviews' Table
resource "aws_dynamodb_table" "dynamodb_reviews" {
    name = var.dynamodb_reviews_table
    billing_mode = "PAY_PER_REQUEST"
    hash_key = var.dynamodb_reviews_table_key

    attribute {
        name = var.dynamodb_reviews_table_key
        type = "S"
    }
}

# 'subscriptions' Table
resource "aws_dynamodb_table" "dynamodb_subscriptions" {
    name = var.dynamodb_subscriptions_table
    billing_mode = "PAY_PER_REQUEST"
    hash_key = var.dynamodb_subscriptions_table_key

    attribute {
        name = var.dynamodb_subscriptions_table_key
        type = "S"
    }
}

# To Create Lambda Function

# Policy which will allow Logging in CloudWatch
resource "aws_iam_policy" "logs_policy" {
    name = "logs_policy"
    policy = data.aws_iam_policy_document.logs_policy.json
}

# IAM Role which will be used for Lambda 
resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
    managed_policy_arns = [ 
        aws_iam_policy.logs_policy.arn
    ]
}

# Lambda-DynamoDB Policy Attachment
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    role = aws_iam_role.iam_for_lambda.name
}

# Lambda-S3 Policy Attachment
resource "aws_iam_role_policy_attachment" "lambda_s3_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    role = aws_iam_role.iam_for_lambda.name
}

# To Create Lambda Function
resource "aws_lambda_function" "acr_lambda_function" {
  filename = "lambda_function.zip"
  function_name = var.lambda_function
  role = aws_iam_role.iam_for_lambda.arn
  handler = "lambda.lambda_handler"
  timeout = 900
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime = "python3.12" 
}

# Permission of Execution from S3 Bucket
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.acr_lambda_function.arn
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.acr_bucket.arn
}

# To Trigger Lambda when File is Uploaded to S3 Bucket
resource "aws_s3_bucket_notification" "acr_lambda_trigger" {
    bucket = aws_s3_bucket.acr_bucket.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.acr_lambda_function.arn
        events = [ "s3:ObjectCreated:*" ]
        filter_suffix = ".csv"
    }

    depends_on = [ aws_lambda_permission.allow_bucket ]
}

# To Create EC2 Instance

# Security Group

resource "aws_security_group" "acr_security_group" {
    name = "acr_security_group"

    # To allow all Inbound HTTP Traffic
    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # To allow all Inbound SSH Traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # To allow all Inbound HTTPS Traffic
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # To allow all Inbound Traffic for Flask 
    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # To allow all Outbound Traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# To Creat Elastic IP
resource "aws_eip" "acr_eip" {
    domain = "vpc"
}

resource "aws_instance" "backend_ec2" {
    # Change to AMI -> e.g "ami-06231032460e61143" if Required (Which is Created with Latest Changes)
    ami = data.aws_ami.amazonlinux.id
    instance_type = var.backend_instance_type
    key_name = "${local.aws_key_value_pair}"

    # To add Security Group where Inbound and Outbound Traffic Rules are defined
    security_groups = [aws_security_group.acr_security_group.name]

    # To run Backend Application
    user_data = <<-EOF
                    #!/bin/bash
                    echo "Credentials Used: "
                    echo "AWS Access Key: ${var.aws_access_key}"
                    echo "AWS Secret Key: ${var.aws_secret_access_key}"
                    echo "GitHub Username: ${var.github_username}"
                    echo "GitHub Personal Access Token: ${var.github_pat}"

                    echo "Initial Directory..."
                    pwd

                    echo "After cd /home/ec2-user"
                    cd /home/ec2-user

                    pwd

                    echo "Installing Git..."
                    sudo yum install git -y

                    echo "Cloning Repository..."
                    git clone https://${var.github_username}:${var.github_pat}@github.com/${var.github_username}/SWEN614-Team7.git

                    echo "After Cloning Repository..."
                    pwd

                    echo "Installing Python..."
                    sudo yum install python -y

                    echo "After cd SWEN614-Team7"
                    cd SWEN614-Team7

                    pwd

                    echo "Creating and Activating Virtual Environment..."
                    python -m venv venv
                    source venv/bin/activate

                    echo "Installing Requirements..."
                    pip install -r requirements.txt

                    echo "Assigning Environment Variables..."
                    echo "AWS_REGION=${var.aws_region}" >> .env
                    echo "AWS_ACCESS_KEY_ID=${var.aws_access_key}" >> .env
                    echo "AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key}" >> .env

                    echo "Starting Backend Application..."
                    python backend/src/server.py
              EOF

    tags = {
      Name = "Backend EC2"
    }
}

# To Associate Elastic IP with EC2
resource "aws_eip_association" "acr_eip_backend_association" {
    instance_id = aws_instance.backend_ec2.id
    allocation_id = aws_eip.acr_eip.id

    depends_on = [ aws_instance.backend_ec2 ]
}

# IAM Role which will be used for Amplify 
resource "aws_iam_role" "iam_for_amplify" {
    name = "iam_for_amplify"
    assume_role_policy = data.aws_iam_policy_document.amplify_assume_role.json
}

# Amplify Policy Attachment
resource "aws_iam_role_policy_attachment" "amplify_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
    role = aws_iam_role.iam_for_amplify.name
}

# To host forntned on AWS Amplify App
resource "aws_amplify_app" "sentiment_app" {
    name = "sentiment-app"
    repository = "https://github.com/comkar893/SWEN614-Team7.git"


    #github access token
    access_token = var.github_pat

    iam_service_role_arn = aws_iam_role.iam_for_amplify.arn

    # The default build_spec added by the Amplify Console for React.
    build_spec = <<-EOT
        version: 1
        applications:
        - backend:
            phases:
                build:
                    commands:
                    - '# Execute Amplify CLI with the helper script'
                    - amplifyPush --simple
          frontend:
            phases:
                preBuild:
                    commands:
                    - npm install
                    - npm ci
                    - sed -i "s/^REACT_APP_AWS_EC2_EIP=.*/REACT_APP_AWS_EC2_EIP=${aws_eip.acr_eip.public_ip}/" .env || echo "REACT_APP_AWS_EC2_EIP=${aws_eip.acr_eip.public_ip}" >> .env
                build:
                    commands:
                    - npm run build
            artifacts:
                baseDirectory: build
                files:
                - '**/*'
            cache:
                paths:
                - node_modules/**/*
          appRoot: frontend/sentiment
    EOT

    custom_rule {
        source = "</^[^.]+$|\\.(?!(css|gif|ico|jpeg|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
        status = "200"
        target = "/index.html"
  }
}

  resource "aws_amplify_branch" "main" {
    app_id      = aws_amplify_app.sentiment_app.id
    branch_name = "main"

    framework = "React"
    stage     = "PRODUCTION"
}