# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kmycli/version'

Gem::Specification.new do |spec|
  spec.name          = "kmycli"
  spec.version       = KMyCLI::VERSION
  spec.authors       = ["Max Hollmann"]
  spec.email         = ["mail@maxhollmann.de"]
  spec.description   = %q{Desc}
  spec.summary       = %q{Sum}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['kmycli']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "activerecord"
  spec.add_runtime_dependency "inifile"
end