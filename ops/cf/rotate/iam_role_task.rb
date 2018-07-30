## permissions needed for running container
resource :iamroletask, 'AWS::IAM::Role' do
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
  policies [
    {
      PolicyName: :IamList,
      PolicyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Effect: :Allow,
            Action: [
              'iam:List*',
            ],
            Resource: '*'
          }
        ]
      }
    }
  ]
end