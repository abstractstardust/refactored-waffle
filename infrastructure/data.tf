data "archive_file" "ssl_lambda" {
  type             = "zip"
  output_path      = "${path.module}/files/lambda.zip"
  source_dir       = "${path.module}/../function"
  output_file_mode = "0666"
}