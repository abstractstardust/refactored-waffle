output "base_url" {
  description = "Base URL for API Gateway stage."
  value = aws_api_gateway_stage.certficate_api_stage.invoke_url
}