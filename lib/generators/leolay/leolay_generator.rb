require File.join(File.dirname(__FILE__), '../active_leonardo')

class LeolayGenerator < Rails::Generators::Base
  include ::ActiveLeonardo::Base

  source_root File.expand_path('../templates', __FILE__)
  argument :style,              :type => :string,   :default => "active"
  #class_option :pagination,    :type => :boolean,  :default => true,   :desc => "Include pagination files"
  class_option :main_color,     :type => :string,   :default => nil,    :desc => "Force a main color for the stylesheet"
  class_option :second_color,   :type => :string,   :default => nil,    :desc => "Force a secondary color for the stylesheet"
  class_option :authentication, :type => :boolean,  :default => true,   :desc => "Add code to manage authentication with devise"
  class_option :authorization,  :type => :boolean,  :default => true,   :desc => "Add code to manage authorization with cancan"
  class_option :activeadmin,    :type => :boolean,  :default => true,   :desc => "Add code to manage activeadmin gem"
  class_option :auth_class,     :type => :string,   :default => 'User', :desc => "Set the authentication class name"
  #class_option :formtastic,    :type => :boolean,  :default => true,   :desc => "Copy formtastic files into leosca custom folder (inside project)"
  #class_option :jquery_ui,     :type => :boolean,  :default => true,   :desc => "To use jQuery ui improvement"
  class_option :rspec,          :type => :boolean,  :default => true,   :desc => "Include custom rspec generator and custom templates"
  class_option :verbose,        :type => :boolean,  :default => true,   :desc => "Run interactive mode"

  def generate_layout
    template "styles/#{style_name}/stylesheets/app/stylesheet.css.scss",          "app/assets/stylesheets/#{style_name}.css.scss"
    template "styles/#{style_name}/stylesheets/app/custom_active_admin.css.scss", "app/assets/stylesheets/custom_active_admin.css.scss"
    template "styles/#{style_name}/stylesheets/app/_enviroment.css.scss",         "app/assets/stylesheets/_enviroment.css.scss"

    copy_file "app/helpers/layout_helper.rb",     "app/helpers/layout_helper.rb",           :force => !options.verbose?
    directory "styles/#{style_name}/images",      "app/assets/images/styles/#{style_name}", :force => !options.verbose?
    copy_file "styles/#{style_name}/favicon.ico", "app/assets/images/favicon.ico",          :force => !options.verbose?

    copy_file "styles/#{style_name}/views/layout/application.html.erb", "app/views/layouts/application.html.erb",    :force => true
    copy_file "styles/#{style_name}/views/layout/_message.html.erb",    "app/views/application/_message.html.erb",   :force => !options.verbose?
    copy_file "styles/#{style_name}/views/layout/_session.html.erb",    "app/views/application/_session.html.erb",   :force => !options.verbose? if options.authentication?

    copy_file "config/initializers/config.rb", "config/initializers/config.rb", :force => !options.verbose?
    template "config/config.yml", "config/config.yml"

    locale_path = "config/locales"
    source_paths.each do |source_path|
      files = Dir["#{source_path}/#{locale_path}/*.yml"]
      files.each do |f|
        if f.include?("devise")
          copy_file f, "#{locale_path}/#{File.basename(f)}", :force => !options.verbose? if options.authentication?
        else
          copy_file f, "#{locale_path}/#{File.basename(f)}", :force => !options.verbose?
        end
      end
      break if files.any?
    end
  end

  def setup_application

    application do
      <<-FILE.gsub(/^      /, '')
      config.generators do |g|
            g.stylesheets         false
            g.javascripts         true
            g.leosca_controller   :leosca_controller
          end

          config.autoload_paths += %W(\#{config.root}/lib/extras)
          I18n.enforce_available_locales = false
      FILE
    end

    file = "app/controllers/application_controller.rb"
    if File.exists?(file)
      inject_into_class file, ApplicationController do
        <<-FILE.gsub(/^      /, '')
        rescue_from CanCan::AccessDenied do |exception|
          redirect_to root_url, :alert => exception.message
        end
        def current_ability
          @current_ability ||= Ability.new(current_#{options[:auth_class].downcase})
        end
        FILE
      end if options.authorization?

      inject_into_class file, ApplicationController do
        <<-FILE.gsub(/^      /, '')
        before_filter :localizate

        def localizate
          if params[:lang]
            session[:lang] = params[:lang]
          else
            session[:lang] ||= I18n.default_locale
          end
          I18n.locale = session[:lang]
        end
        FILE
      end
    end

  end

  def setup_authentication
    file = "app/models/#{options[:auth_class].downcase}.rb"
    #puts "File #{file} #{File.exists?(file) ? "" : "does not"} exists!"
    return unless options.authentication? and File.exists?(file)

    inject_into_class file, auth_class do
      <<-FILE.gsub(/^    /, '')
      ROLES = %w[admin manager user guest]
      scope :with_role, lambda { |role| {:conditions => "roles_mask & \#{2**ROLES.index(role.to_s)} > 0 "} }

      def roles=(roles)
        self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
      end
      def roles
        ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
      end
      def role_symbols
        roles.map(&:to_sym)
      end
      def role?(role)
        roles.include? role.to_s
      end
      def roles?(*roles)
        roles.each do |role|
          return true if role? role
        end
        nil
      end
      def admin?
        self.role? 'admin'
      end
      FILE
    end

  end

  def setup_authorization
    file = "app/models/ability.rb"
    return unless File.exists?(file)
    gsub_file file, /initialize(\s|\()user(.|)/, "initialize(#{options[:auth_class].downcase})"
    inject_into_file file, :before => "  end\nend" do
      <<-FILE.gsub(/^      /, '')
          #{options[:auth_class].downcase} ||= #{auth_class}.new
          can :manage, :all if #{options[:auth_class].downcase}.role? :admin
          alias_action :batch_action, :to => :update
          can :read, ActiveAdmin::Page, :name => "Dashboard"
      FILE
    end
  end

  def create_users_for_development
    return unless options.authentication?
    file = "db/seeds.rb"
    append_file file do
      <<-FILE.gsub(/^      /, '')
      #{auth_class}.delete_all if #{auth_class}.count == 1
      user=#{auth_class}.new :email => 'admin@#{app_name}.com', :password => 'abcd1234', :password_confirmation => 'abcd1234'
      #{"user.roles=['admin']" if options.authorization?}
      user.save
      user=#{auth_class}.new :email => 'manager@#{app_name}.com', :password => 'abcd1234', :password_confirmation => 'abcd1234'
      #{"user.roles=['manager']" if options.authorization?}
      user.save
      user=#{auth_class}.new :email => 'user@#{app_name}.com', :password => 'abcd1234', :password_confirmation => 'abcd1234'
      #{"user.roles=['user']" if options.authorization?}
      user.save
      FILE
    end if File.exists?(file)
  end

  #def setup_formtastic
  #  return unless options.formtastic?
  #
  #end

  def setup_javascript
    app_path = "app/assets/javascripts"

    file = "#{app_path}/custom.js.coffee"
    copy_file file, file, :force => !options.verbose?

    file = "#{app_path}/active_admin.js.coffee"
    #gsub_file file, "#= require active_admin/base" do
    #  <<-FILE.gsub(/^    /, '')
    #  #= require jquery.turbolinks
    #
    #  #= require active_admin/base
    #FILE
    #end
    append_file file do
      <<-FILE.gsub(/^      /, '')
      #= require turbolinks
      #= require custom
      FILE
    end
  end

  #def setup_stylesheets
  #end

  def setup_rspec
    file = "spec/spec_helper.rb"
    return unless File.exists?(file) && options.rspec?
    inject_into_file file, :after => "require 'rspec/rails'" do
    <<-FILE.gsub(/^    /, '')

    require 'capybara/rspec'
    require 'helpers/application_helpers'

    Capybara.default_wait_time = 10 #default=2
    FILE
    end

    gsub_file file, 'config.fixture_path = "#{::Rails.root}/spec/fixtures"', '#config.fixture_path =  "#{::Rails.root}/spec/fixtures"'
    #inject_into_file file, "#", :before => 'config.fixture_path = "#{::Rails.root}/spec/fixtures"'

    gsub_file file, "config.use_transactional_fixtures = true" do
    <<-FILE.gsub(/^  /, '')
  config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.include ApplicationHelpers
    FILE
    end

    file = "spec/factories.rb"
    copy_file file, file, :force => !options.verbose?
    file = "spec/support/devise.rb"
    copy_file file, file, :force => !options.verbose?
    file = "spec/helpers/application_helpers.rb"
    copy_file file, file, :force => !options.verbose?

  end

  def setup_extras
    copy_file "lib/upd_array.rb", "lib/extras/upd_array.rb", :force => !options.verbose?
  end

  def setup_activeadmin
    return unless options.activeadmin? and activeadmin?
    template "config/initializers/activeadmin_leonardo.rb", "config/initializers/activeadmin_leonardo.rb"
    #copy_file "config/initializers/activeadmin_cancan.rb", "config/initializers/activeadmin_cancan.rb" if options.authorization?
    #template "app/admin/users.rb", "app/admin/#{options[:auth_class].downcase.pluralize}.rb"
    file = "app/admin/#{options[:auth_class].downcase}.rb"
    inject_into_file file, :after => "ActiveAdmin.register #{options[:auth_class]} do" do
      <<-FILE.gsub(/^      /, '')

        controller do
          def update
            unless params[:user]['password'] && params[:user]['password'].size > 0
              params[:user].delete 'password'
              params[:user].delete 'password_confirmation'
            end
            super do
              #do something
            end
          end
        end
      FILE
    end


    file = "app/assets/stylesheets/active_admin.css.scss"
    append_file file do
      <<-FILE.gsub(/^      /, '')

      @import "custom_active_admin";
      FILE
    end if File.exists?(file)

    file = "config/initializers/active_admin.rb"
    gsub_file file, 'config.fixture_path = "#{::Rails.root}/spec/fixtures"', '#config.fixture_path =  "#{::Rails.root}/spec/fixtures"'
    #inject_into_file file, "#", :before => 'config.fixture_path = "#{::Rails.root}/spec/fixtures"'

    gsub_file file, "# config.authorization_adapter = ActiveAdmin::CanCanAdapter" do
      <<-FILE.gsub(/^      /, '')
        config.authorization_adapter = ActiveAdmin::CanCanAdapter
      FILE
    end if File.exists?(file)
  end

  private
  def style_name
    style.underscore
  end

  def app_name
    File.basename(Dir.pwd)
  end

end
