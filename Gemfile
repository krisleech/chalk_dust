source 'https://rubygems.org'

gemspec

platforms :ruby do
  gem "sqlite3", :platform => :ruby
end

platforms :jruby do
  gem "activerecord-jdbcsqlite3-adapter"
end

group :development do
  gem 'guard-rspec'
end
