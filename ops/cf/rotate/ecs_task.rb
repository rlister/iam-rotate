resource :ecstask, 'AWS::ECS::TaskDefinition', DependsOn: [:loggroup, :iamroleexec, :iamroletask] do
  cpu 256
  memory '0.5GB'
  requires_compatibilities [:FARGATE]
  execution_role_arn Fn::get_att(:iamroleexec, :Arn)
  task_role_arn Fn::get_att(:iamroletask, :Arn)
  network_mode :awsvpc
  container_definitions [
    Name: 'iam-rotate',
    Image: Fn::sub('${AWS::AccountId}.dkr.ecr.${AWS::Region}.amazonaws.com/iam-rotate:latest'),
    Memory: 256,
    Environment: [
      {Name: 'AWS_REGION',    Value: Fn::ref('AWS::Region')},
      {Name: 'OPSGENIE_KEY',  Value: Fn::ref(:opsgenie)},
      {Name: 'MAX_AGE',       Value: 90},
      {Name: 'SLACK_WEBHOOK', Value: Fn::ref(:slack)},
    ],
    LogConfiguration: {
      LogDriver: :awslogs,
      Options: {
        'awslogs-group'         => Fn::ref(:loggroup),
        'awslogs-region'        => Fn::ref('AWS::Region'),
        'awslogs-stream-prefix' => :ops,
      }
    }
  ]
end

output :EcsTask, Fn::ref(:ecstask)