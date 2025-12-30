# frozen_string_literal: true

require_relative 'lib/jenkins/peace/version'

Gem::Specification.new do |s|
  s.name        = 'jenkins-peace'
  s.version     = Jenkins::Peace::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nrodriguez@jbox-web.com']
  s.homepage    = 'http://jbox-web.github.io/jenkins-peace/'
  s.summary     = %q{Fetch and use a specific Jenkins version with Rubygems}
  s.description = %q{Download and install a specific version of the Jenkins war file which can be used for either running a server, or for plugin development}
  s.license     = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.bindir      = 'exe'
  s.executables = ['jenkins.peace']

  s.add_runtime_dependency 'net-http'
  s.add_runtime_dependency 'ostruct'
  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'ruby-progressbar'
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'tty-table'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
end
