require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'
require File.join(File.dirname(__FILE__), '../../active_leonardo')

WINDOWS = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)
CRLF = WINDOWS ? "\r\n" : "\n"

module Rails
  module Generators
    class LeoscaControllerGenerator < ::Rails::Generators::ScaffoldControllerGenerator
      include ::ActiveLeonardo::Base
      include ::ActiveLeonardo::Leosca
      include ::ActiveLeonardo::Leosca::Locale
      include ::ActiveLeonardo::Leosca::Rspec
      include ::ActiveLeonardo::Leosca::Seed
      include ::ActiveLeonardo::Leosca::Activeadmin

      source_root File.expand_path('../templates', __FILE__)
      argument :attributes,         :type => :array,    :default => [],     :banner => "field:type field:type"
      class_option :seeds,          :type => :boolean,  :default => true,                                       :desc => "Create seeds to run with rake db:seed"
      class_option :seeds_elements, :type => :string,   :default => "30",   :banner => "NUMBER",                :desc => "Choose seeds elements"
      #class_option :remote,        :type => :boolean,  :default => true,                                       :desc => "Enable ajax. You can also do later set remote to true into index view."
      #class_option :under,         :type => :string,   :default => "",     :banner => "brand/category",        :desc => "To nest a resource under another(s)"
      #class_option :leospace,      :type => :string,   :default => "",     :banner => ":admin",                :desc => "To nest a resource under namespace(s)"
      class_option :auth_class,     :type => :string,   :default => 'User',                                     :desc => "Set the authentication class name"
      class_option :activeadmin,    :type => :boolean,  :default => true,                                       :desc => "Add code to manage activeadmin gem"

      #Override
      def create_controller_files
        template 'controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end

      #Override
      #hook_for :template_engine, :test_framework, :as => :leosca

      def update_yaml_locales
        #Inject model and attributes name into yaml files for i18n
        path = "config/locales"
        files = Dir["#{path}/??.yml"]
        files.each do |file|

          next unless File.exists?(file)

          #Fields name
          inject_into_file file, :after => "#Attributes zone - do not remove" do
            attributes_to_list(attributes, file_name)
          end

          #Model name
          inject_into_file file, :after => "models: &models" do
            <<-FILE.gsub(/^      /, '')

            #{file_name}: "#{file_name.capitalize}"
            #{controller_name}: "#{controller_name.capitalize}"
            FILE
          end

          #Formtastic
          inject_into_file file, :after => "#Hints zone - do not remove" do
            attributes_to_hints(attributes, file_name)
          end

        end
      end

      def update_ability_model
        return unless authorization?
        inject_into_file authorization_file, :before => "  end\nend" do
          <<-FILE.gsub(/^      /, '')

          # ----- #{class_name.upcase} ----- #
          can :read, #{class_name}                                if #{options[:auth_class].downcase}.role? :guest
          can [:read, :create, :update], #{class_name}            if #{options[:auth_class].downcase}.role? :user
          can [:read, :create, :update, :destroy], #{class_name}  if #{options[:auth_class].downcase}.role? :manager
          FILE
        end
      end

      def add_seeds_db
        return unless options.seeds? and options[:seeds_elements].to_i > 0
        file = "db/seeds.rb"
        append_file file do
          items = []
          attributes.each{|attribute| items << attribute_to_hash(attribute)}
          row = "{ #{items.join(', ')} }"

          #TODO: to have different values for every row
          content = "#{CRLF}### Created by leosca controller generator ### #{CRLF}"
          attributes.each{|attribute| content << attribute_to_range(attribute)}
          if /^3./ === Rails.version
            content << attributes_accessible(attributes, class_name)
          end
          content << "#{class_name}.create([#{CRLF}"
          options[:seeds_elements].to_i.times do |n|
            content << "#{row.gsub(/\#/, (n+1).to_s)},#{CRLF}"
          end
          content << "])#{CRLF}"
          content
        end if File.exists?(file)
      end

      def invoke_active_admin
        return unless activeadmin? && options[:activeadmin]

        invoke "active_admin:resource", [singular_table_name]
        file = "app/admin/#{singular_table_name}.rb"


        inject_into_file file, :after => "ActiveAdmin.register #{class_name} do" do
          <<-FILE.gsub(/^          /, '')
            # ActiveLeonardo: Remove comments where you need it
            #index do
            #  selectable_column
            #  id_column
          #{attributes_to_aa_index(attributes)}
            #  actions
            #end

            #show do |#{singular_table_name}|
            #  attributes_table do
            #    row :id
          #{attributes_to_aa_show(attributes)}
            #    row :created_at
            #    row :updated_at
            #  end
            #  # Insert here child tables
            #  #panel I18n.t('models.childs') do
            #  #  table_for #{singular_table_name}.childs do
            #  #    column(:id) {|child| link_to child.id, [:admin, child]}
            #  #  end
            #  #end
            #  active_admin_comments
            #end

          #{attributes_to_aa_filter(attributes)}

            #form do |f|
            #  f.inputs do
          #{attributes_to_aa_form(attributes)}
            #  end
            #  f.actions
            #end

            #csv do
          #{attributes_to_aa_csv(attributes)}
            #end
          FILE
        end if File.exists?(file)

        if /^[4-5]/ === Rails.version
          inject_into_file file, :after => "ActiveAdmin.register #{class_name} do" do
            <<-FILE.gsub(/^            /, '')
              permit_params do
                permitted = [:id, #{attributes_to_aa_permit_params(attributes)}, :created_at, :updated_at]
                permitted
              end

            FILE
          end if File.exists?(file)
        end

        inject_into_file file, :after => "ActiveAdmin.register #{class_name} do" do
          <<-FILE.gsub(/^          /, '')

            menu :if => proc{ can?(:read, #{class_name}) }

            controller do
              load_resource :except => :index
            end

          FILE
        end if authorization? && File.exists?(file)

      end

      def update_specs
        file = "spec/spec_helper.rb"
        return unless File.exists? file

        file = "spec/factories.rb"
        inject_into_file file, :before => "  ### Insert below here other your factories ###" do
          items = []
          attributes.each do |attribute|
            items << attribute_to_factories(attribute)
          end
          <<-FILE.gsub(/^        /, '')

          factory :#{singular_table_name} do |#{singular_table_name[0..0]}|
        #{items.join(CRLF)}
          end
          FILE
        end if File.exists?(file)
      end

    end
  end
end
