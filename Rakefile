require 'rake'
require 'rspec/core/rake_task'

desc 'Start unit tests'
task test: :spec
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |config|
    config.rspec_opts = '--color'
  end
  Rake::Task['spec'].invoke
end

desc 'Install latest Jenkins war file'
task default: :prepare
task :prepare do
  begin
    require 'bundler/setup'
    require 'jenkins_peace'
    Jenkins::Peace::ConsoleLogger.new().info("Installing Jenkins war file version : 'latest'")
    Jenkins::Peace.install('latest')
    Jenkins::Peace::ConsoleLogger.new().info('Done !')
  rescue
    puts "Failed to install Jenkins war, you'll have to install it yourself with 'jenkins.peace install <version>'"
  end
end
