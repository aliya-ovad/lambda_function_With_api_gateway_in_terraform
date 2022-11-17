

## AWS lambda function with API
* [General info](#general-info)
* [Calculator](#calculator)
* [Setup](#setup)

## General info
A simple project in terraform that takes two numbers and adds them together.
	
## Calculator

To access the calculator through the browser:
1. Click the link [calculator](https://msf42klrm1.execute-api.eu-central-1.amazonaws.com/calculator/GET)

2. If you want to send data to the calculator We need to send two numbers First number and Second number
   
   You need to replace the <Value_for_First_number> and <Value_for_Second_number> with your numbers

   https://msf42klrm1.execute-api.eu-central-1.amazonaws.com/calculator/GET
   
   ?firstnumber=<Value_for_First_number>&secondnumber=<Value_for_Second_number
   
 #### For example :  
 
 If I want to send the numbers 17 and 5 The link will look like this

 https://msf42klrm1.execute-api.eu-central-1.amazonaws.com/calculator/GET?firstnumber=17&secondnumber=5
   
#### The result will be:  
 ```
 
 "firstnumber : 17   secondnumber : 5     17 plus 5 equals: 22"
 
 ```
	
## Setup

#### Prerequisites :
* terraform
* aws cli

#### To run this project :

```
$ git clone https://github.com/aliya-ovad/lambda_function_With_api_gateway_in_terraform.git
$ cd lambda_function_With_api_gateway_in_terraform/Terraform
$ terraform init
$ terraform apply
```
#### to destroy the project :

```
$ terraform destroy
```

#### Personal customization

In this project I used SNS that sends the results to email 

You need to change the value here [variables.tf](/Terraform/variables.tf)

