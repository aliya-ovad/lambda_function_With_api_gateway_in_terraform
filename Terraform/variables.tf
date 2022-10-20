variable "aws_region" {

  description = "AWS region for all resources."
  type    = string
  default = "eu-central-1"
}

variable "sns_email" {

  description = "sns email"
  type    = string
  default = "alya.ovad.2015@gmail.com"
}
variable "Account_id" {

  description = "You only need to change the 12 digits of the account ID"
  type    = string
  default = "arn:aws:sns:eu-central-1:040500316512:sns_for_calculator"
}
