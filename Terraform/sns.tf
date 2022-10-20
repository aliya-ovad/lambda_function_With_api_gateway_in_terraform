resource "aws_sns_topic" "sns_for_calculator" {
  name = "sns_for_calculator"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.sns_for_calculator.arn
  protocol  = "email"
  endpoint  = var.sns_email
  
}
