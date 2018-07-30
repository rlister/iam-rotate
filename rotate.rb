#!/usr/bin/env ruby
# encoding: utf-8

require 'aws-sdk-iam'
require 'opsgenie/send'
require 'json'

MAX_AGE = ENV['MAX_AGE'].to_i
WEBHOOK = ENV['SLACK_WEBHOOK']

def iam
  @iam ||= Aws::IAM::Client.new
end

def user_names
  iam.list_users.users.map(&:user_name)
end

def has_old_key?(user)
  iam.list_access_keys(user_name: user).access_key_metadata.any? do |k|
    age = ((Time.now - k.create_date)/(60*60*24)).to_i
    age > MAX_AGE
  end
end

def users_with_old_keys
  user_names.select do |u|
    has_old_key?(u)
  end
end

def slack(message)
  uri = URI.parse(WEBHOOK)
  https = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.path)
  request.body = {text: message}.to_json
  https.use_ssl = true
  https.request(request)
end

## run the check
guilty = users_with_old_keys
puts 'users with old keys:', guilty.join(' ')

## report to slack
unless guilty.empty?
  slack("The following users need to rotate access keys: #{guilty.join(', ')}")
end

## if we got here, send heartbeat to opsgenie to prove we are running
puts Opsgenie::Send.heartbeat('Access key check')