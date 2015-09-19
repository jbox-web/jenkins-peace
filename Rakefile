require 'bundler'
Bundler::GemHelper.install_tasks

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
  require 'jenkins_peace'
  Jenkins::Peace.install('latest')
end
