resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# needs iam policy to allow logs to be created & written.

resource "aws_iam_policy" "iam_for_lambda" {
  name        = "iam_for_lambda_policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_for_lambda.arn
}

# create the log group to ensure it exists

resource "aws_cloudwatch_log_group" "ssl_lambda" {
  name = "/aws/lambda/ssl_checker"
}

resource "aws_lambda_function" "ssl_lambda" {
  filename         = data.archive_file.ssl_lambda.output_path
  function_name    = "ssl_checker"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "main.ssl_cert_check_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.ssl_lambda.output_base64sha256
  environment {
    variables = {
      DOMAIN = "https://play.runescape.com/" # I assume by argument fearless is asking for the domain to be a variable
    }
  }
  depends_on = [
    data.archive_file.ssl_lambda
  ]
}
