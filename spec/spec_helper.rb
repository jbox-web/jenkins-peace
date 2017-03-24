require 'rubygems'
require 'simplecov'
require 'rspec'
require 'pullreview/coverage_reporter'

## Configure SimpleCov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  PullReview::Coverage::Formatter
])

## Start Simplecov
SimpleCov.start do
  add_filter '/spec/'
end

## Configure RSpec
RSpec.configure do |config|
  config.color = true
  config.fail_fast = false
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ENV['RACK_ENV'] = 'test'
require 'jenkins_peace'

JENKINS_WAR_URL      = 'http://mirrors.jenkins-ci.org/war/'
BASE_PATH            = File.join(ENV['HOME'], '.jenkins')
WAR_FILES_CACHE      = File.join(ENV['HOME'], '.jenkins', 'war-files')
WAR_UNPACKED_CACHE   = File.join(ENV['HOME'], '.jenkins', 'wars')
SERVER_PATH          = File.join(ENV['HOME'], '.jenkins', 'server')
SERVER_COMMAND_LINE  = [
  'java',
  "-Djava.io.tmpdir=#{File.join(SERVER_PATH, 'javatmp')}",
  '-jar',
  File.join(WAR_FILES_CACHE, '1.630', 'jenkins.war'),
  '--httpPort=3001',
  '--controlPort=3002'
]
