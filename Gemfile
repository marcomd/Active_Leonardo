source 'https://rubygems.org'
case ENV['CI_RAILS']
  when '3.2'
    gem 'rails', '>= 3.2.17', '< 4.0.0'
    gem 'coffee-rails'
    gem 'sass-rails'
  when '4.0'
    gem 'rails', '>= 4.0.4', '< 4.1.0'
    gem 'coffee-rails', '~> 4.0.0'
    gem 'sass-rails', '~> 4.0.0'
  else
    gem 'rails', '4.0.3'
    gem 'coffee-rails'
    gem 'sass-rails'
end

gem "active_leonardo", :path => "."
gem "sqlite3"
gem "rspec-rails", group: [:test, :development]
gem "capybara", group: :test
gem "launchy", group: :test
gem "database_cleaner", group: :test
gem "activeadmin", git: "https://github.com/gregbell/active_admin.git"
gem "cancan"