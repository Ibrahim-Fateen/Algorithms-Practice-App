source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.6'

# Rails core gems
gem 'rails', '~> 7.0.8'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'

# Asset pipeline and frontend
gem 'sprockets-rails'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'tailwindcss-rails'

# Authentication and Authorization
gem 'devise'

gem 'docker-api'
gem 'sidekiq'

# Reduces boot times through caching
gem 'bootsnap', require: false

# Development and testing gems
group :development, :test do
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
end

group :development do
  gem 'web-console'
  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
end