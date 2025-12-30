# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

# Start Simplecov
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter])
  add_filter '/spec/'
end

# Configure RSpec
RSpec.configure do |config|
  config.color = true
  config.fail_fast = false

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.raise_errors_for_deprecations!
end

ENV['RACK_ENV'] = 'test'

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

# Load our gem
require 'jenkins_peace'
