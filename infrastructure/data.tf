data "archive_file" "ssl_lambda" {
  type             = "zip"
  output_path      = "${path.module}/files/lambda.zip"
  source_file      = "${path.module}/files/main.py" # I set this while debugging to ensure that file gets zipped on every terraform plan / apply
  output_file_mode = "0666"
}
