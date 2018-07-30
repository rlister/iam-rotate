## permission for scheduled event to invoke lambda
resource :perm, 'AWS::Lambda::Permission', DependsOn: [:lambda, :event] do
  function_name Fn::ref(:lambda)
  action 'lambda:InvokeFunction'
  principal 'events.amazonaws.com'
  source_arn Fn::get_att(:event, :Arn)
end