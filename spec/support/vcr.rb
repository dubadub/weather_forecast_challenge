require "vcr"

VCR.configure do |config|
  config.ignore_hosts "127.0.0.1", "localhost"
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = { record: :new_episodes, re_record_interval: 3.days }
  config.hook_into :webmock
  config.cassette_library_dir = Rails.root.join("tmp", "vcr_cassettes")
  config.configure_rspec_metadata!
end
