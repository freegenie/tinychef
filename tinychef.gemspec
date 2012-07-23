# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tinychef/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Fabrizio Regini"]
  gem.email         = ["freegenie@gmail.com"]
  gem.description   = %q{Simple command line tool for Chef Solo recipes}
  gem.summary       = %q{Simple command line tool for Chef Solo recipes}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tinychef"
  gem.require_paths = ["lib"]
  gem.version       = Tinychef::VERSION
end
