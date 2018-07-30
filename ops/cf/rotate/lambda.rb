## read file containing lambda code
code = File.read(File.join(File.dirname(__FILE__), 'lambda.py'))

resource :lambda, 'AWS::Lambda::Function', DependsOn: [:iamrolelambda] do
  role Fn::get_att(:iamrolelambda, :Arn)
  code do
    zip_file code
  end
  environment do
    variables(
      CLUSTER: Fn::ref(:cluster),
      TASKDEF: Fn::ref(:ecstask),
      SUBNETS: Fn::import_value(Fn::sub('${vpc}-SubnetIds')),
    )
  end
  handler 'index.handler'
  runtime 'python2.7'
  memory_size 128
  Timeout 60
end