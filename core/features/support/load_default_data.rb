# load default data for tests
require 'active_record/fixtures'
fixtures_dir = File.expand_path('../../../db/default', __FILE__)
Fixtures.create_fixtures(fixtures_dir, ['countries', 'zones', 'zone_members', 'states', 'roles'])
Fabricate(:shipping_method, :name => "UPS Ground")
Fabricate(:payment_method_check, :name => "Check")

# use transactions for faster tests
DatabaseCleaner.strategy = :transaction
