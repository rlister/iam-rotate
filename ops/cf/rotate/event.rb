resource :event, 'AWS::Events::Rule', DependsOn: [:lambda] do
  description 'Ops check for unrotated IAM keys'
  schedule_expression 'rate(24 hours)'
  state :ENABLED
  targets [
    {
      Id:  Fn::ref(:lambda),
      Arn: Fn::get_att(:lambda, :Arn),
    }
  ]
end