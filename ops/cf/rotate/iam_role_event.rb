## permissions needed for Cloudwatch Event to invoke ECS task
resource :iamroleevent, 'AWS::IAM::Role', DependsOn: [:ecstask] do
  path '/ops/'
  assume_role_policy_document(
    Version: '2012-10-17',
    Statement: [
      {
        Effect: :Allow,
        Principal: {
          Service: 'events.amazonaws.com'
        },
        Action: 'sts:AssumeRole'
      }
    ]
  )
  policies [
    {
      PolicyName: :EcsInvoke,
      PolicyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Effect: :Allow,
            Action: 'ecs:RunTask',
            Resource: Fn::sub('arn:aws:ecs:${AWS::Region}:${AWS::AccountId}:task-definition/*'),
            Condition: {
              ArnLike: {
                'ecs:cluster': Fn::sub('arn:aws:ecs:${AWS::Region}:${AWS::AccountId}:cluster/${cluster}')
              }
            }
          }
        ]
      }
    }
  ]
end