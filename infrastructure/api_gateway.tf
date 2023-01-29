# API Gateway
# Create API
resource "aws_api_gateway_rest_api" "certficate_api" {
  name        = "CertficateAPI"
  description = "An API for validating SSL certificates."
}

# Resource - domain
resource "aws_api_gateway_resource" "api_domain_resource" {
  rest_api_id = aws_api_gateway_rest_api.certficate_api.id
  parent_id   = aws_api_gateway_rest_api.certficate_api.root_resource_id
  path_part   = "{domain}"
}

# GET Request Method
resource "aws_api_gateway_method" "api_domain_method" {
  rest_api_id   = aws_api_gateway_rest_api.certficate_api.id
  resource_id   = aws_api_gateway_resource.api_domain_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate API Gateway and Lambda Function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.certficate_api.id
  resource_id             = aws_api_gateway_resource.api_domain_resource.id
  http_method             = aws_api_gateway_method.api_domain_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ssl_lambda.invoke_arn
}

# Deployment
resource "aws_api_gateway_deployment" "certficate_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.certficate_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_domain_resource.id,
      aws_api_gateway_method.api_domain_method.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Stage Settings for API
resource "aws_api_gateway_stage" "certficate_api_stage" {
  deployment_id = aws_api_gateway_deployment.certficate_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.certficate_api.id
  stage_name    = "alpha"
}