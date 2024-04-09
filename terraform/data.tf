data "aws_ami" "amazonlinux" {
    most_recent = true
    owners     = ["amazon"]

    filter {
        name="name"
        values = ["al2023-ami-2023*"]
    }
    filter {
        name="virtualization-type"
        values = ["hvm"]
    }
    filter {
        name="root-device-type"
        values = ["ebs"]
    }
    filter {
        name="architecture"
        values = ["x86_64"]
    }
}

# Assume Role [Trusted Entity]
data "aws_iam_policy_document" "amplify_assume_role" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["amplify.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

# Assume Role [Trusted Entity]
data "aws_iam_policy_document" "lambda_assume_role" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

# CloudWatch Logs Policy
data "aws_iam_policy_document" "logs_policy" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:us-east-1:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:us-east-1:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

# To get Lambda Function Code
data "archive_file" "lambda_function" {
    type        = "zip"
    source_file = "lambda.py"
    output_path = "lambda_function.zip"
}