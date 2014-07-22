source 'https://rubygems.org'
case ENV['CI_RAILS']
  when '3.2'
    gem 'rails', '~> 3.2'
    gem 'coffee-rails'
    gem 'sass-rails'
  when '4.0'
    gem 'rails', '~> 4.0'
    gem 'coffee-rails', '~> 4.0'
    gem 'sass-rails', '~> 4.0'
  when '4.1'
    gem 'rails', '~> 4.1'
    gem 'sprockets', '~> 2.11', '<= 2.11'
    gem 'sprockets-rails', '~> 2.0'
    #gem 'coffee-rails'
    #gem 'sass-rails'
    #gem 'ransack'                     ,  git: 'https://github.com/activerecord-hackery/ransack.git',     branch: 'rails-4.1'
    #gem 'polyamorous'                 ,  git: 'https://github.com/activerecord-hackery/polyamorous.git'
    gem 'formtastic', '~> 2.3.0.rc3'  #,  git: 'https://github.com/justinfrench/formtastic.git'
    gem 'tzinfo-data'
  else
    gem 'rails'
    gem 'coffee-rails'
    gem 'sass-rails'
end

gem "active_leonardo", :path => "."
gem "sqlite3"
gem "rspec-rails",      group: [:test, :development]
gem "capybara",         group: :test
gem "launchy",          group: :test
gem "database_cleaner", group: :test
gem "activeadmin",      git: "https://github.com/gregbell/active_admin.git"
#gem "activeadmin",      path: "test/active_admin-d2997b995c98"
gem "cancan"
gem "devise", "~> 3.2"
