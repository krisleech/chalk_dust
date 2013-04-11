class ChalkDustRailtie < Rails::Railtie
  generators do
    require "chalk_dust/rails/generators/install_migrations"
  end
end
