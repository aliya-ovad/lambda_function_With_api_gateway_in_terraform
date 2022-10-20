import json
import boto3
import os

def lambda_handler(event, context):
    try:
        # Extract variables from api
        
        firstnumber     = (event["queryStringParameters"]["firstnumber"])
        secondnumber    = (event["queryStringParameters"]["secondnumber"])
        sumofcalculator = f"""firstnumber : {firstnumber}   secondnumber : {secondnumber}     {firstnumber} plus {secondnumber} equals: {int(firstnumber) + int(secondnumber)}"""
        
        # Sending an email with the results
        
        
        client   = boto3.client('sns')
        snsArn   = os.environ['id']
        response = client.publish(
                   TopicArn = snsArn,
                   Message  = sumofcalculator,
                   Subject  ='calculator')
       
    except:
        
        # Message in case no parameters have been entered
        
        sumofcalculator   = 'please enter firstnumber and secondnumber And you will get their sum together'
        
    return{
            'statusCode': 200 ,
            'body': json.dumps(sumofcalculator)
          }