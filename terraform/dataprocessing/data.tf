# Assume Role [Trusted Entity]
data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

# DynamoDB Policy
data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "dynamodb:*",
      "dax:*",
      "application-autoscaling:DeleteScalingPolicy",
      "application-autoscaling:DeregisterScalableTarget",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:DescribeScalingActivities",
      "application-autoscaling:DescribeScalingPolicies",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:RegisterScalableTarget",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:GetMetricData",
      "datapipeline:ActivatePipeline",
      "datapipeline:CreatePipeline",
      "datapipeline:DeletePipeline",
      "datapipeline:DescribeObjects",
      "datapipeline:DescribePipelines",
      "datapipeline:GetPipelineDefinition",
      "datapipeline:ListPipelines",
      "datapipeline:PutPipelineDefinition",
      "datapipeline:QueryObjects",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "iam:GetRole",
      "iam:ListRoles",
      "kms:DescribeKey",
      "kms:ListAliases",
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:ListSubscriptions",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTopics",
      "sns:Subscribe",
      "sns:Unsubscribe",
      "sns:SetTopicAttributes",
      "lambda:CreateFunction",
      "lambda:ListFunctions",
      "lambda:ListEventSourceMappings",
      "lambda:CreateEventSourceMapping",
      "lambda:DeleteEventSourceMapping",
      "lambda:GetFunctionConfiguration",
      "lambda:DeleteFunction",
      "resource-groups:ListGroups",
      "resource-groups:ListGroupResources",
      "resource-groups:GetGroup",
      "resource-groups:GetGroupQuery",
      "resource-groups:DeleteGroup",
      "resource-groups:CreateGroup",
      "tag:GetResources",
      "kinesis:ListStreams",
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:cloudwatch:*:*:insight-rule/DynamoDBContributorInsights*"]
    actions   = ["cloudwatch:GetInsightRuleReport"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:PassRole"]

    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"

      values = [
        "application-autoscaling.amazonaws.com",
        "application-autoscaling.amazonaws.com.cn",
        "dax.amazonaws.com",
      ]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"

      values = [
        "replication.dynamodb.amazonaws.com",
        "dax.amazonaws.com",
        "dynamodb.application-autoscaling.amazonaws.com",
        "contributorinsights.dynamodb.amazonaws.com",
        "kinesisreplication.dynamodb.amazonaws.com",
      ]
    }
  }
}

# S3 Policy
data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:*",
      "s3-object-lambda:*",
    ]
  }
}

# CloudWatch Logs Policy
data "aws_iam_policy_document" "logs_policy" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:us-east-1:851725641731:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:us-east-1:851725641731:*"]

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
