# IAM Rotation Check

Users need to rotate IAM access keys periodically. This checks for
outdated keys and sends a reminder to slack.

## Docker image creation

After any script update:

```
docker build -t xxx.dkr.ecr.us-east-1.amazonaws.com/iam-rotate .
eval $(aws ecr get-login --no-include-email)
docker push xxx.dkr.ecr.us-east-1.amazonaws.com/iam-rotate
```

## Running the script

Set AWS vars (key and secret not needed on ops hosts with correct IAM
roles) and Opsgenie key. Args to the container are a list of regexes
for stacks to backup, e.g.:

```
docker run --name iam-rotate \
  -e AWS_REGION \
  -e OPSGENIE_KEY \
  -e MAX_AGE \
  -e SLACK_WEBHOOK \
  xxx.dkr.ecr.us-east-1.amazonaws.com/iam-rotate
```