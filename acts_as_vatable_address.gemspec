# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_vatable_address/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_vatable_address"
  spec.version       = ActsAsVatableAddress::VERSION
  spec.authors       = ["Denny Carl"]
  spec.email         = ["denny.carl@googlemail.com"]
  spec.summary       = %q{Add EU VAT related functionality to a class.}
  spec.description   = %q{Add EU VAT related functionality to a class.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 3.0"
  
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "sqlite3"
end
