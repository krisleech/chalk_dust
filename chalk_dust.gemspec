# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chalk_dust/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kris Leech"]
  gem.email         = ["kris.leech@gmail.com"]
  gem.description   = %q{Subscribe to and build activity feeds for your models, for example followings and friendships}
  gem.summary       = %q{Subscribe to and build activity feeds for your models, for example followings and friendships}
  gem.homepage      = "https://github.com/krisleech/chalk-dust"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "chalk_dust"
  gem.require_paths = ["lib"]
  gem.version       = ChalkDust::VERSION

  gem.add_dependency "activerecord", "~> 3.0"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec", "~> 2.3"
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency "sqlite3-ruby"
end
