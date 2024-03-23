variable "backend_instance_type" {
    type        = string
    description = "Instance type for running Backend"
    default     = "t2.micro"
}

locals {
    aws_key_value_pair = "<Your Key Value Pair>" # Change this to your Key-Value Pair
  }

variable "github_username" {
    type        = string
    description = "GitHub Username"
    default     = "<GitHub Repository Admin's Username>" # Change this to Repositoy Admin's Username
}

variable "github_pat" {
    type        = string
    description = "GitHub Personal Access Token"
    default     = "<GitHub Repository Admin's PAT>" # Change this to Repositoy Admin's Personal Access Token
}

variable "aws_region" {
    type        = string
    description = "AWS Region"
    default     = "<Desired AWS Region>" # Change this to your desired region e.g 'us-east-1'
}

variable "aws_access_key" {
    type        = string
    description = "AWS Access Keys"
    default     = "<Your AWS Root Access Key>" # Change this to your Root Access Key
}

variable "aws_secret_access_key" {
    type        = string
    description = "AWS Secret Access Keys"
    default     = "<Your AWS Root Secret Access Key>" # Change this to your Root Secret Access Key
}