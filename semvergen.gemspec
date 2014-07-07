# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semvergen/version'

Gem::Specification.new do |spec|
  spec.name          = "semvergen"
  spec.version       = Semvergen::VERSION
  spec.authors       = ["Brendon McLean"]
  spec.email         = ["brendon@intellectionsoftware.com"]
  spec.summary       = "Interactive semantic version and gem publishing"
  spec.homepage      = "https://github.com/brendon9x/semvergen"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "highline", "~> 1.6"
  spec.add_runtime_dependency "thor", "~> 0.14"
  spec.add_runtime_dependency "geminabox"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.0"
end
