ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  self.use_transactional_fixtures = false
  setup do
    DatabaseCleaner.start
  end
  teardown do
    DatabaseCleaner.clean
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end
