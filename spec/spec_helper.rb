require 'simplecov'
SimpleCov.start

require 'active_record'
require 'chalk_dust'

puts "Using ActiveRecord #{ActiveRecord::VERSION::STRING}"

adapter = RUBY_PLATFORM == "java" ? 'jdbcsqlite3' : 'sqlite3'

ActiveRecord::Base.establish_connection(:adapter => adapter,
                                        :database => File.dirname(__FILE__) + "/db.sqlite3")

load File.dirname(__FILE__) + '/support/schema.rb'

require 'support/models'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
