# S3 Bucket Name
variable "s3_bucket" {
    type = string
    description = "S3 Bucket Name"
    default = "acr-sentiment-bucket-team-7"
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