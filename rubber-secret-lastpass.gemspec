# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubber/secret/lastpass/version'

Gem::Specification.new do |spec|
  spec.name          = "rubber-secret-lastpass"
  spec.version       = Rubber::Secret::Lastpass::VERSION
  spec.authors       = ["Dave Benvenuti"]
  spec.email         = ["davebenvenuti@gmail.com"]
  spec.summary       = %q{Manage your Rubber secret with a shared Lastpass note}
  spec.description   = %q{Manage your Rubber secret with a shared Lastpass note}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"

  spec.add_dependency "cocaine"
  spec.add_dependency "highline"
end
