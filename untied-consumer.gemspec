# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'untied-consumer/version'

Gem::Specification.new do |gem|
  gem.name          = "untied-consumer"
  gem.version       = Untied::Consumer::VERSION
  gem.authors       = ["Guilherme Cavalcanti"]
  gem.email         = ["guiocavalcanti@gmail.com"]
  gem.description   = "Provides the Consumer part of the Untied gem."
  gem.summary       = "Untied is a Observer Pattern implementation for distributed systems. Think as a cross-application ActiveRecord::Observer. This gem handles the listening of events"
  gem.homepage      = "http://github.com/redu/untied"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake"

  gem.add_runtime_dependency "activemodel"
  gem.add_runtime_dependency "amqp"
  gem.add_runtime_dependency "configurable"
  gem.add_runtime_dependency "json"

  if RUBY_VERSION < "1.9"
    gem.add_development_dependency "ruby-debug"
  else
    gem.add_development_dependency "debugger"
  end
end
