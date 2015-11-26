# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codebreaker/version'

Gem::Specification.new do |spec|
  spec.name          = "sarcasm-codebreaker"
  spec.version       = Codebreaker::VERSION
  spec.authors       = ["SarCasm"]
  spec.email         = ["sarcasm008@gmail.com"]

  spec.summary       = %q{Gem for RubyGarage courses}
  spec.description   = %q{Codebreaker game. Play & have fun}
  spec.homepage      = "http://this.page"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   << 'codebreaker'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
