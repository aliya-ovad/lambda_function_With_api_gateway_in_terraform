resource "random_pet" "lambda_bucket_name" {
  prefix = "calculator"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}
resource "aws_s3_object" "lambda_function" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = data.archive_file.py_to_zip.output_path
  etag = filemd5(data.archive_file.py_to_zip.output_path)
}

resource "aws_lambda_function" "calculator" {
  function_name = "calculator"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_function.key
  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.py_to_zip.output_base64sha256
  role = aws_iam_role.role_lambda_calculator.arn
  environment {
    variables = {
      id = var.Account_id
    }
  }
}

resource "aws_cloudwatch_log_group" "calculator_logs" {
  name = "/aws/lambda/${aws_lambda_function.calculator.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "role_lambda_calculator" {
  name = "role_lambda_calculator"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.role_lambda_calculator.name
  for_each = toset([
    "arn:aws:iam::aws:policy/CloudWatchFullAccess", 
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
  ])
  policy_arn = each.value
}
