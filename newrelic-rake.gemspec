# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic-rake/version'

Gem::Specification.new do |gem|
  gem.name          = "newrelic-rake"
  gem.version       = Newrelic::Rake::VERSION
  gem.authors       = ["Richard Huang"]
  gem.email         = ["flyerhzm@gmail.com"]
  gem.description   = %q{newrelic instrument for rake task}
  gem.summary       = %q{newrelic instrument for rake task.}
  gem.homepage      = ""

  gem.add_dependency 'newrelic_rpm',         '>= 3.1.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
