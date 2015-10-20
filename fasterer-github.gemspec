# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fasterer/github/version'

Gem::Specification.new do |spec|
  spec.name          = 'fasterer-github'
  spec.version       = Fasterer::Github::VERSION
  spec.authors       = ['Kacper Goliński']
  spec.email         = ['kacper.golinski@gmail.co']

  spec.summary       = 'Fasterer extension which allows to scan github repo. '
  spec.homepage      = 'https://github.com/caspg/fasterer-github'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'

  spec.add_runtime_dependency 'fasterer', '0.1.11'
  spec.add_runtime_dependency 'httparty'
end
