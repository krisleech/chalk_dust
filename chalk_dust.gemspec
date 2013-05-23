# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chalk_dust/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kris Leech"]
  gem.email         = ["kris.leech@gmail.com"]
  gem.description   = <<-DESC
    Subscriptions connect models, events build activity feeds.

    Designed to scale.

    ChalkDust can be used to build activty feeds such as followings and
    friendships by allowing models to subscribe to activity feeds published by
    other models.

    Every time an activity occurs it is copied to all subscribers of the target
    of that activity. This creates an activty feed per subscriber. This results
    in more data but scales better and allows additional features such as the
    ability of the subscriber to delete/hide activity items.

    Each publisher can create multiple feeds by means of topics. For example a
    user might publish activities with topics of 'family' or 'work'.

    Please check the documentation <https://github.com/krisleech/chalk_dust>.
  DESC
  gem.summary               = %q{Subscribe to and build activity feeds for your models, for example followings and friendships. Build to scale.}
  gem.homepage              = "https://github.com/krisleech/chalk_dust"
  gem.license               = "MIT"

  gem.files                 = `git ls-files`.split($\)
  gem.executables           = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.name                  = "chalk_dust"
  gem.require_paths         = ["lib"]
  gem.version               = ChalkDust::VERSION
  gem.required_ruby_version = ">= 1.9.2"

  gem.add_dependency "activerecord", ">= 3.0.0"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec", "~> 2.3"
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'

  if defined? JRUBY_VERSION
    gem.add_development_dependency "activerecord-jdbcsqlite3-adapter"
  else
    gem.add_development_dependency "sqlite3"
  end
end
