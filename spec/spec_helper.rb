require 'spork'

# http://stackoverflow.com/questions/6721491/pgerror-no-connection-to-the-server-on-running-specs-with-spork

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'

  require "rails/application"
  Spork.trap_method(Rails::Application, :reload_routes!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # CAPYBARA
  require 'capybara/rspec'
  # uses FF
  Capybara.default_driver = :selenium
  #Capybara.default_driver = :webkit
  # uses something internal
  Capybara.javascript_driver = :selenium
  #Capybara.javascript_driver = :webkit

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    config.before(:each) do
      #ActiveSupport::Dependencies.clear
      #AccountInitializer.register_new_account_classes

      #if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
      #else
      #  DatabaseCleaner.strategy = :truncation
      #end
      DatabaseCleaner.start
      #Rake::Task["db:seed"].invoke

      # reload factories
      FactoryGirl.factories.clear
      FactoryGirl.find_definitions
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
end
