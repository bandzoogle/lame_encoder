# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lame_encoder/version'

Gem::Specification.new do |gem|
  gem.name          = "lame_encoder"
  gem.version       = Lame::VERSION
  gem.authors       = ["Colin Mitchell"]
  gem.email         = ["muffinista@gmail.com"]
  gem.description   = %q{wrapper around lame mp3 encoder}
  gem.summary       = %q{wrapper around lame mp3 encoder}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency(%q<rake>, [">= 0"])
  gem.add_development_dependency(%q<rspec>, [">= 2.12.0"])
end
