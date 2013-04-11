require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module ChalkDust
  module Generators
    class InstallMigrations < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)

      desc "Generates (but does not run) the migrations for chalk dust"
      def install_migrations
        migration_template "migration.rb", "db/migrate/chalk_dust_create_tables"
      end
    end
  end
end
