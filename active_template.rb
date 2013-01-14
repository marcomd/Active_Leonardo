#########################################################
# 2012 Marco Mastrodonato(c)
# This is a Rails 3.1+ template to use with activeleonardo gem
# https://rubygems.org/gems/Activeleonardo
# 
# USAGE: rails new yourappname -m active_template.rb
# 
# -------------------------------------------------------
#
#########################################################

puts '*' * 40
puts "* Processing template..."
puts '*' * 40

use_git = yes?("Do you use git ?")
if use_git
  git :init
  file ".gitignore", <<-EOS.gsub(/^    /, '')
    # See http://help.github.com/ignore-files/ for more about ignoring files.
    #
    # If you find yourself ignoring temporary files generated by your text editor
    # or operating system, you probably want to add a global ignore instead:
    #   git config --global core.excludesfile ~/.gitignore_global

    # Ignore bundler config
    /.bundle
    # Ignore the default SQLite database.
    /db/*.sqlite3
    # Ignore all logfiles and tempfiles.
    /log/*.log
    /tmp
    /nbproject
    /.idea
    lib/tasks/files/*
    /*.cmd
    /*.dat
  EOS
end

gem "rack-mini-profiler"
gem "turbolinks"
gem "jquery-turbolinks"

gem "activeadmin"
gem "active_admin_editor"
gem "meta_search"
gem "active_leonardo"

rspec = yes?("Add rspec as testing framework ?")
if rspec
  gem 'rspec-rails', :group => [:test, :development]
  gem 'capybara', :group => :test
  gem 'launchy', :group => :test
  gem 'database_cleaner', :group => :test
  if /1.8.*/ === RUBY_VERSION
    gem 'factory_girl', '2.6.4', :group => :test
    gem 'factory_girl_rails', '1.7.0', :group => :test
  else
    gem 'factory_girl_rails', :group => :test
  end
end

authentication = yes?("Authentication ?")
model_name = authorization = nil
if authentication
  default_model_name = "User"
  model_name = ask(" Insert model name: [#{default_model_name}]")
  if model_name.empty? || model_name == 'y'
    model_name = default_model_name
  else
    model_name = model_name.classify
    stdout = <<-REMEM.gsub(/^    /, '')
    *************************************************************************
    Remember to add your auth class when you use active leonardo's generator.
    For example: 
    rails g leosca Product name price:decimal --auth_class=#{model_name}
    *************************************************************************
    REMEM
    p stdout
  end
  
  authorization = yes?("Authorization ?")
  if authorization
    gem 'cancan'
    gem 'activeadmin-cancan'
  end
end

gem 'state_machine' if yes?("Do you have to handle states ?")

dashboard_root = yes?("Would you use dashboard as root ? (recommended)")
home = yes?("Ok. Would you create home controller as root ?") unless dashboard_root

if yes?("Bundle install ?")
  dir = ask(" Insert folder name to install locally: [blank=default gems path]")
  run "bundle install #{"--path=#{dir}" unless dir.empty? || dir=='y'}"
end

generate "rspec:install" if rspec

generate "active_admin:install #{authentication ? model_name : "--skip-users"}"
generate "active_admin:editor"

if authorization
  generate "cancan:ability"
  generate "migration", "AddRolesMaskTo#{model_name}", "roles_mask:integer"
end

generate  "leolay",
            "active", #specify theme
            "--auth_class=#{model_name}",
            (rspec ? nil : "--skip-rspec"),
            (authorization ? nil : "--skip-authorization"),
            (authentication ? nil : "--skip-authentication")


if dashboard_root
  route "root :to => 'admin/dashboard#index'"
elsif home
  generate "controller", "home", "index"
  route "root :to => 'home#index'"
end

File.unlink "public/index.html"

rake "db:create:all"
rake "db:migrate"
rake "db:seed"

#rake "gems:unpack" if yes?("Unpack to vendor/gems ?")
if use_git
  git :add    => "."
  git :commit => %Q{ -m 'Initial commit' }
end

puts "ENJOY!"
