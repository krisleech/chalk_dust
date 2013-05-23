source 'https://rubygems.org'

gemspec

group :test do
  platforms :ruby do
    gem "sqlite3"
  end

  platforms :jruby do
    gem "activerecord-jdbcsqlite3-adapter"
  end
end

group :development do
  gem 'guard-rspec'
end
