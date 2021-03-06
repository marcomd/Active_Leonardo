#########################################################
# 2016 Marco Mastrodonato(c)
# This is a Rails 5.x template to use with activeleonardo gem
# https://rubygems.org/gems/active_leonardo
# https://github.com/marcomd/Active_Leonardo
# 
# USAGE: rails new yourappname -m active_template.rb
# 
# -------------------------------------------------------
#
#########################################################

rails_version = Rails::VERSION::STRING

puts '*' * 40
puts "* Rails #{rails_version} Processing template..."
puts '*' * 40

test_mode = nil
ARGV.each{|arg| test_mode = true if arg  == "test_mode"}
app_path = ARGV[1]
puts "**** Starting app into #{app_path} in test mode! ****" if test_mode

use_git = test_mode || yes?("Do you use git ?")

if use_git
  git :init
  remove_file ".gitignore"
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
    /config/initializers/secret_token.rb
  EOS
end

gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin'

if test_mode
  gem "active_leonardo",    path: "../../."
else
  gem "active_leonardo"
end
gem "jquery-turbolinks"
gem "bourbon"

easy_develop = test_mode || yes?("Do you want to make development easier?")
if easy_develop
  gem "rack-mini-profiler", group: :development
  gem "better_errors",      group: :development
  gem "awesome_print",      group: :development
end

rspec = test_mode || yes?("Add rspec as testing framework ?")
if rspec
  gem 'rspec-rails',                    group: [:test, :development]
  gem 'capybara',                       group: :test
  gem 'launchy',                        group: :test
  gem 'database_cleaner',               group: :test
  gem 'factory_girl_rails',             group: :test
end

authentication  = test_mode || yes?("Authentication ?")
model_name      = authorization = nil
if authentication
  default_model_name  = "User"
  model_name          = test_mode ? "" : ask(" Insert model name: [#{default_model_name}]")
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
  if /^5/ === rails_version    
    gem "devise", git: "https://github.com/plataformatec/devise"
  else
    gem "devise"
  end

  authorization = test_mode || yes?("Authorization ?")
  if authorization
    gem "cancan"
  end
end

gem 'state_machines' if test_mode || yes?("Do you have to handle states ?")

gem 'inherited_resources'
if /^5/ === rails_version    
  gem 'formtastic', git: 'https://github.com/justinfrench/formtastic.git'
else
  gem 'formtastic'
end

dashboard_root = test_mode || yes?("Would you use dashboard as root ? (recommended)")
home = test_mode || yes?("Ok. Would you create home controller as root ?") unless dashboard_root

if test_mode || yes?("Bundle install ?")
  dir = test_mode ? "" : ask(" Insert folder name to install locally: [blank=default gems path]")
  run "bundle install #{"--path=#{dir}" unless dir.empty? || dir=='y'}"
end

generate "rspec:install" if rspec

generate "active_admin:install #{authentication ? model_name : "--skip-users"}"

if authorization
  generate "cancan:ability"
  generate "migration", "AddRolesMaskTo#{model_name}", "roles_mask:integer"
end

generate  "leolay",
          "active", #specify theme
          "--auth_class=#{model_name}",
          (rspec ?                  nil : "--skip-rspec"),
          (authorization ?          nil : "--skip-authorization"),
          (authentication ?         nil : "--skip-authentication"),
          (test_mode ?  "--no-verbose"  : nil)


if dashboard_root
  route "root :to => 'admin/dashboard#index'"
elsif home
  generate "controller", "home", "index"
  route "root :to => 'home#index'"
end

rake "db:create:all"
rake "db:migrate"
rake "db:seed"

#rake "gems:unpack" if yes?("Unpack to vendor/gems ?")
if use_git
  git :add => "."
  git :commit => %Q{ -m "Initial commit" }
end

puts "ENJOY!"