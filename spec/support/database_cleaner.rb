RSpec.configure do |config|

  # Clear test database before running tests
  # Truncation style deletion comes with more options for active_record
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Transaction cleaning strategy is recommended the fastest for SQL based DB's
  # It works by rolling back commits
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Beginning tracking of transactions before each test
  config.before(:each) do
    DatabaseCleaner.start
  end

  # Commit to rolling back transactions after each test
  config.after(:each) do
    DatabaseCleaner.clean
  end
end