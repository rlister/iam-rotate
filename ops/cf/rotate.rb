description 'Ops IAM key rotation'

## VPC stack
parameter :vpc, type: :String

parameter :cluster,  type: :String, description: 'ECS cluster for tasks to run'
parameter :opsgenie, type: :String, description: 'Opsgenie API token'
parameter :slack,    type: :String, description: 'Slack webhook URL' # https://hooks.slack.com/services/xxx/xxx/xxx

include_template(
  'rotate/log_group.rb',
  'rotate/iam_role_exec.rb',
  'rotate/iam_role_task.rb',
  'rotate/ecs_task.rb',
  'rotate/iam_role_lambda.rb',
  'rotate/lambda.rb',
  'rotate/event.rb',
  'rotate/perm.rb',
)