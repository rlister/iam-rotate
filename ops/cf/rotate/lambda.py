import os
import boto3

def handler(event, context):
  ecs = boto3.client('ecs')
  response = ecs.run_task(
    cluster = os.getenv('CLUSTER'),
    launchType = 'FARGATE',
    taskDefinition = os.getenv('TASKDEF'),
    count = 1,
    platformVersion = 'LATEST',
    networkConfiguration = {
      'awsvpcConfiguration': {
        'subnets': os.getenv('SUBNETS').split(','),
        'assignPublicIp': 'ENABLED'
      }
    }
  )
  print response
  return str(response)