# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strut/version'

Gem::Specification.new do |spec|
  spec.name          = "strut"
  spec.version       = Strut::VERSION
  spec.authors       = ["Dan Cutting"]
  spec.email         = ["dan@cutting.io"]

  spec.summary       = %q{Acceptance testing with Swagger}
  spec.homepage      = "https://github.com/dcutting/strut"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ["strut"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "equivalent-xml"

  spec.add_dependency "term-ansicolor", "~> 1.3"
  spec.add_dependency "rubyslim", "~> 0.1"
end
