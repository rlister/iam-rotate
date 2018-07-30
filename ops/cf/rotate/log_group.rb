resource :loggroup, 'AWS::Logs::LogGroup' do
  log_group_name Fn::sub('/ops/${AWS::StackName}')
  retention_in_days 90
end

output :LogGroup, Fn::ref(:loggroup)