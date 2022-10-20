terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}


data "archive_file" "py_to_zip" {
  type = "zip"
  source_dir  = "${path.module}/python"
  output_path = "${path.module}/lambda_function.zip"
}


resource "aws_apigatewayv2_api" "api_calculator" {
  name          = "api_calculator"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_calculator_stage" {
  api_id = aws_apigatewayv2_api.api_calculator.id
  name        = "calculator"
  auto_deploy = true
  access_log_settings {
  destination_arn = aws_cloudwatch_log_group.calculator_logs.arn
  format = jsonencode({
  requestId               = "$context.requestId"
  sourceIp                = "$context.identity.sourceIp"
  requestTime             = "$context.requestTime"
  protocol                = "$context.protocol"
  httpMethod              = "$context.httpMethod"
  resourcePath            = "$context.resourcePath"
  routeKey                = "$context.routeKey"
  status                  = "$context.status"
  responseLength          = "$context.responseLength"
  integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}
resource "aws_apigatewayv2_integration" "api_integration" {
  api_id = aws_apigatewayv2_api.api_calculator.id
  integration_uri    = aws_lambda_function.calculator.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "api_route" {
  api_id = aws_apigatewayv2_api.api_calculator.id
  route_key = "GET /GET"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.api_calculator.name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.calculator.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.api_calculator.execution_arn}/*/*"
}
