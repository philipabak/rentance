source 'https://rubygems.org'

gem 'rails', '~> 4.2'

# Data handling
gem 'pg'
gem 'strip_attributes'              # Strip attributes before validation
gem 'has_scope'                     # Handling scopes from controller
gem 'thinking-sphinx'
gem 'mysql2'                        # Required by Sphinx
gem 'carmen-rails'                  # Countries and provinces
# gem 'geocoder'                      # Geolocation
# gem 'seed_dump'                     # Dumping data to seed.rb file
gem 'friendly_id'                   # Slugs
# gem 'bcrypt'                        # Use ActiveModel has_secure_password
# gem 'addressable'                   # URI handling
# gem 'domainatrix'                   # Domain handling

# GeoIP by MaxMind
gem 'maxminddb'

# File uploader
gem 'paperclip'
gem 'remotipart'                    # Rails jQuery file uploads via standard Rails "remote: true" forms
gem 'aws-sdk', '< 2.0'              # Photo storage

# Background job processor
# gem 'resque', '~> 1.25.0', require: 'resque/server'
# gem 'resque-cleaner'
# gem 'resque-pool'

# Data representation
gem 'jbuilder'                      # JSON builder
gem 'kaminari'                      # Pagination

# Assets management
gem 'slim-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'therubyracer', platforms: :ruby, require: 'v8'
gem 'autoprefixer-rails'            # Adds vendor prefixes to CSS rules

# Assets
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'selectize-rails'
gem 'autosize-rails'
gem 'summernote-rails'
gem 'jquery-fileupload-rails'
gem 'fastclick-rails'               # Library to remove click delays on browsers with touch UIs

gem 'whenever', require: false      # Cron jobs

gem 'puma'

gem 'rack-mini-profiler', require: false  # Profiling
gem 'ffaker'                        # Random data generator

group :test do
  gem 'factory_girl_rails'          # Test data factories
  gem 'mocha', require: false       # Method stubs and mocks

  gem 'simplecov', require: false   # Code coverage
  gem 'minitest-reporters'          # Beautified test output
  gem 'guard-minitest'              # Running tests in background
  gem 'rails-perftest'              # Performance testing
  gem 'ruby-prof'                   # Profiler
end

group :development do
  gem 'guard'
  gem 'spring'
  gem 'better_errors'
  gem 'web-console'
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false

  gem 'meta_request'                # Support for RailsPanel (Google Chrome extension)
  # gem 'mailcatcher' # Disabling mailcatcher due to conflict with other gems
end

group :production do
  # gem 'newrelic_rpm'
  gem 'dalli'
end
