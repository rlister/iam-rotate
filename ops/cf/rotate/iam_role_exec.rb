## permissions needed for ECS agent on Fargate to pull image and exec container
resource :iamroleexec, 'AWS::IAM::Role' do
  path '/ops/'
  assume_role_policy_document(
    Version: '2012-10-17',
    Statement: [
      {
        Effect: :Allow,
        Principal: {
          Service: 'ecs-tasks.amazonaws.com'
        },
        Action: 'sts:AssumeRole'
      }
    ]
  )
  managed_policy_arns [
    'arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy',
  ]
end