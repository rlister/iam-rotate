## service role for lambda to execute
resource :iamrolelambda, 'AWS::IAM::Role' do
  path '/ops/'
  assume_role_policy_document(
    Version: '2012-10-17',
    Statement: [
      {
        Effect: :Allow,
        Principal: {
          Service: 'lambda.amazonaws.com'
        },
        Action: 'sts:AssumeRole'
      }
    ]
  )
  managed_policy_arns(
    [
      'arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole',
    ]
  )
  policies [
    {
      PolicyName: :EcsRunTask,
      PolicyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Effect: :Allow,
            Action: [
              'ecs:RunTask'
            ],
            Resource: Fn::ref(:ecstask)
          },
          {
            Effect: :Allow,
            Action: [
              'iam:PassRole'
            ],
            Resource: [
              Fn::get_att(:iamroleexec, :Arn),
              Fn::get_att(:iamroletask, :Arn),
            ]
          },
        ]
      }
    },
  ]
end