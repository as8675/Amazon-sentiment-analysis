# Provider

provider "aws" {
    region = "us-east-1"
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

# Policy which will allow Reads/Writes to DynamoDB
resource "aws_iam_policy" "dynamodb_policy" {
    name = "dynamodb_policy"
    policy = data.aws_iam_policy_document.dynamodb_policy.json
}

# Policy which will allow Reads from S3
resource "aws_iam_policy" "s3_policy" {
    name = "s3_policy"
    policy = data.aws_iam_policy_document.s3_policy.json
}

# Policy which will allow Logging in CloudWatch
resource "aws_iam_policy" "logs_policy" {
    name = "logs_policy"
    policy = data.aws_iam_policy_document.logs_policy.json
}

# IAM Role which will be used for Lambda 
resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
    managed_policy_arns = [ 
        aws_iam_policy.dynamodb_policy.arn,
        aws_iam_policy.s3_policy.arn,
        aws_iam_policy.logs_policy.arn
    ]
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