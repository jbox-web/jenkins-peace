# frozen_string_literal: true

require_relative 'lib/jenkins/peace/version'

Gem::Specification.new do |s|
  s.name        = 'jenkins-peace'
  s.version     = Jenkins::Peace::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nrodriguez@jbox-web.com']
  s.homepage    = 'http://jbox-web.github.io/jenkins-peace/'
  s.summary     = 'Fetch and use a specific Jenkins version with Rubygems'
  s.description = 'Download and install a specific version of the Jenkins war file which can be used for either running a server, or for plugin development'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.1.0'

  s.files = Dir['README.md', 'CHANGELOG.md', 'LICENSE', 'AUTHORS', 'lib/**/*.rb', 'exe/*']

  s.bindir      = 'exe'
  s.executables = ['jenkins.peace']

  s.add_dependency 'net-http'
  s.add_dependency 'ostruct'
  s.add_dependency 'ruby-progressbar'
  s.add_dependency 'thor'
  s.add_dependency 'tty-table'
end
