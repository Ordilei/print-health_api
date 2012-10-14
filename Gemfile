source 'https://rubygems.org'

ruby '1.8.7'

gem "sinatra", "~> 1.2.6"
gem "rake"
gem "tokamak", "~> 1.2.1"
gem "multi_json"
gem 'heroku'

gem "mongoid", :git => "git://github.com/thoughtworks/mongoid.git"
gem "bson_ext", "~> 1.3"
gem "SystemTimer", ">= 1.2.0"
gem "will_paginate", "~> 3.0.1"  #usado em Evento.search
gem "nokogiri"
gem 'restfulie', '1.0.3'

group :development do
  gem 'shotgun'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'fakeweb'
  gem 'shoulda-matchers'
end

group :test, :development do
  gem 'ruby-debug'
end

group :production do
  gem 'thin'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'


# gem 'debugger'
