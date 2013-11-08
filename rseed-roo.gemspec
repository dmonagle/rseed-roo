# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rseed/roo/version'

Gem::Specification.new do |spec|
  spec.name          = "rseed-roo"
  spec.version       = Rseed::Roo::VERSION
  spec.authors       = ["David Monagle"]
  spec.email         = ["david.monagle@intrica.com.au"]
  spec.description   = %q{Provides a Roo based adapter for Rseed that allows the import of excel files.}
  spec.summary       = %q{Roo adapter for Rseed}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rseed"
  spec.add_dependency "roo"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
