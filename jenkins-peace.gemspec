# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'jenkins/peace/version'

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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'rake',      '~> 10.4', '>= 10.4.2'
  s.add_runtime_dependency 'thor',      '~> 0.19', '>= 0.19.1'
  s.add_runtime_dependency 'tty-table', '~> 0.3', '>= 0.3.0'

  s.add_development_dependency 'rspec',     '~> 3.3',  '>= 3.3.0'
  s.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'
end
