source 'https://rubygems.org'
case ENV['CI_RAILS']
  when /^3\.2/
    gem 'rails', '~> 3.2.0'
    gem 'coffee-rails'
    gem 'sass-rails'
  when /^4\.0/
    gem 'rails', '~> 4.0.0'
    gem 'coffee-rails', '~> 4.0.0'
    gem 'sass-rails', '~> 4.0.0'
  when /^4\.1/
    gem 'rails', '~> 4.1.0'
    gem 'tzinfo-data'
  when /^4\.2/
    gem 'rails', '~> 4.2.0'
    gem 'tzinfo-data'
    gem 'inherited_resources'
  when /^5\.0/
    gem 'rails', '~> 5.0.0.beta2'
    gem 'tzinfo-data'
    gem 'inherited_resources'
  else
    gem 'rails'
    gem 'coffee-rails'
    gem 'sass-rails'
end

gem 'active_leonardo', :path => '.'
gem 'sqlite3'
gem 'rspec-rails',      group: [:test, :development]
gem 'capybara',         group: :test
gem 'launchy',          group: :test
gem 'activeadmin',    git: 'https://github.com/activeadmin/activeadmin.git'
if ENV['CI_RAILS'] == '5.0.BETA'
  gem 'formtastic',       git: 'https://github.com/justinfrench/formtastic.git'
  gem 'devise',           git: 'https://github.com/plataformatec/devise.git'
  gem 'database_cleaner', git: 'https://github.com/pschambacher/database_cleaner', branch: 'rails5.0',  ref: '8dd9fa4'
else
  gem "devise"
  gem 'database_cleaner', group: :test
end
gem 'cancan'
