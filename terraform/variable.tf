# EC2 Instance Type
variable "backend_instance_type" {
    type        = string
    description = "Instance type for running Backend"
    default     = "t2.micro"
}

# EC2 Key Value Pair
locals {
    aws_key_value_pair = "<Your Key Value Pair>" # Change this to your Key-Value Pair
  }

# GitHub Repositoy Admin's Username
variable "github_username" {
    type        = string
    description = "GitHub Username"
    default     = "<GitHub Repository Admin's Username>" # Change this to Repositoy Admin's Username
}

# GitHub Repositoy Admin's Personal Access Token
variable "github_pat" {
    type        = string
    description = "GitHub Personal Access Token"
    default     = "<GitHub Repository Admin's PAT>" # Change this to Repositoy Admin's Personal Access Token
}

# AWS Region
variable "aws_region" {
    type        = string
    description = "AWS Region"
    default     = "us-east-1" # Change this to your desired region e.g 'us-east-1'
}

# AWS Access Key
variable "aws_access_key" {
    type        = string
    description = "AWS Access Keys"
    default     = "<Your AWS Root Access Key>" # Change this to your Root Access Key
}

# AWS Secret Access Key
variable "aws_secret_access_key" {
    type        = string
    description = "AWS Secret Access Keys"
    default     = "<Your AWS Root Secret Access Key>" # Change this to your Root Secret Access Key
}

# S3 Bucket Name
variable "s3_bucket" {
    type = string
    description = "S3 Bucket Name"
    default = "acr-sentiment-bucket-team-7-project" # Update this Value to be Unique e.g 'acr-sentiment-bucket-team-7-<Your Name>'
}

# Lambda Function
variable "lambda_function" {
    type = string
    description = "Lambda Function Name"
    default = "acr-lambda-function-team-7"
}

# DynamoDB Tables

# 'categories' Table

variable "dynamodb_categories_table" {
    type = string
    description = "Categories Table"
    default = "categories"
}

variable "dynamodb_categories_table_key" {
    type = string
    description = "Categories Table Key"
    default = "categoryId"
}

# 'products' Table

variable "dynamodb_products_table" {
    type = string
    description = "Products Table"
    default = "products"
}

variable "dynamodb_products_table_key" {
    type = string
    description = "Products Table Key"
    default = "productId"
}

# 'reviews' Table

variable "dynamodb_reviews_table" {
    type = string
    description = "Reviews Table"
    default = "reviews"
}

variable "dynamodb_reviews_table_key" {
    type = string
    description = "Reviews Table Key"
    default = "reviewId"
}

# 'subscriptions' Table

variable "dynamodb_subscriptions_table" {
    type = string
    description = "Subscriptions Table"
    default = "subscriptions"
}

variable "dynamodb_subscriptions_table_key" {
    type = string
    description = "Subscriptions Table Key"
    default = "subscriptionId"
}