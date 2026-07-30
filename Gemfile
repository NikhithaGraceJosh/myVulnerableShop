source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0.0'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
#use mysql
gem "mysql2"
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Rails 8's default asset pipeline: serves assets without a manifest or
# bundling step, digesting them for cache-busting.
gem 'propshaft'

# Compiles the app's Sass (including Bootstrap's) with the Dart Sass CLI,
# no Node/Yarn required. Pairs with Propshaft.
gem 'dartsass-rails'

# Rails 8's default navigation layer.  JavaScript is delivered with import maps,
# so this replaces the Webpacker-era Turbolinks package.
gem 'turbo-rails'

# Rails 8's default companion to Turbo + Importmap for sprinkles of JS behavior.
gem 'stimulus-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem "mutex_m"
gem "logger"
# CSV is a bundled gem in modern Ruby releases and must be declared explicitly.
gem "csv"
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# gem bootstrap
gem 'bootstrap'

# Provides the `fa_icon` view helper used throughout app/views. Its bundled
# CSS/fonts are unused now -- Font Awesome's CSS is loaded from a CDN instead
# (see app/views/layouts), since the gem only ships a Sprockets-era
# `.css.erb` asset that Propshaft/Dart Sass can't compile.
gem 'font-awesome-rails'

#gem devise
gem 'devise'

# gem simple form
gem 'simple_form'


# gem letter opener
gem 'letter_opener' 

gem 'cocoon'

gem 'acts-as-taggable-on'

gem "paranoia"

# Google Sign In/Up
gem 'omniauth-google-oauth2'

gem 'redis-rails'
gem 'sidekiq'

# payment gateway
gem 'stripe'



gem 'whenever', :require => false
# data confirm modal
gem 'data-confirm-modal'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
 
  # gem rspec
  gem 'rspec-rails', '~> 7.1'

  # gem factory bot
  gem 'factory_bot_rails'

  # gem faker
  gem 'faker'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "importmap-rails", "~> 2.2"
