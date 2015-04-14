# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restminer/version'

Gem::Specification.new do |spec|
  spec.name          = "restminer"
  spec.version       = Restminer::VERSION
  spec.authors       = ["Carlos Peñas"]
  spec.email         = ["carlos.penas@the-cocktail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{Redmine rest client cli.}
  spec.description   = %q{This is a test client for redmine}
  spec.homepage      = "http://github.com/theist/restminer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "pry" , '~> 0'
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "faraday", "~> 0"
  spec.add_dependency "thor", "~> 0"
end
