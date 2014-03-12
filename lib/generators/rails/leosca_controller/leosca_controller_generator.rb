require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'
require File.join(File.dirname(__FILE__), '../../active_leonardo')

WINDOWS = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)
CRLF = WINDOWS ? "\r\n" : "\n"

module Rails
  module Generators
    class LeoscaControllerGenerator < ::Rails::Generators::ScaffoldControllerGenerator
      include ::ActiveLeonardo::Base
      include ::ActiveLeonardo::Leosca

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
            content = "#{CRLF}      #{file_name}:#{CRLF}"
            attributes.each do |attribute|
              content << "        #{attribute.name}: \"#{attribute.name.humanize}\"#{CRLF}"
            end
            #content << "        op_new: \"New #{singular_table_name}\"#{CRLF}"
            #content << "        op_edit: \"Editing #{singular_table_name}\"#{CRLF}"
            #content << "        op_edit_multiple: \"Editing #{plural_table_name}\"#{CRLF}"
            #content << "        op_copy: \"Creating new #{plural_table_name}\"#{CRLF}"
            #content << "        op_index: \"Listing #{plural_table_name}\"#{CRLF}"
            content
          end

          #Model name
          inject_into_file file, :after => "models: &models" do
            <<-FILE.gsub(/^      /, '')

            #{file_name}: "#{file_name.capitalize}"
            #{controller_name}: "#{controller_name.capitalize}"
            FILE
          end

          #Formtastic
          inject_into_file file, :after => "    hints:" do
            content = "#{CRLF}      #{file_name}:#{CRLF}"
            attributes.each do |attribute|
              attr_name = attribute.name.humanize
              case attribute.type
              when :integer, :decimal, :float
                content << "        #{attribute.name}: \"Fill the #{attr_name} with a#{"n" if attribute.type == :integer} #{attribute.type.to_s} number\"#{CRLF}"
              when :boolean
                content << "        #{attribute.name}: \"Select if this #{file_name} should be #{attr_name} or not\"#{CRLF}"
              when :string, :text
                content << "        #{attribute.name}: \"Choose a good #{attr_name} for this #{file_name}\"#{CRLF}"
              when :date, :datetime, :time, :timestamp
                content << "        #{attribute.name}: \"Choose a #{attribute.type.to_s} for #{attr_name}\"#{CRLF}"
              else
                content << "        #{attribute.name}: \"Choose a #{attr_name}\"#{CRLF}"
              end
            end
            content
          end

        end
      end

      def update_ability_model
        return unless authorization?
        inject_into_file authorization_file, :before => "  end\nend" do
          <<-FILE.gsub(/^      /, '')

          # ----- #{class_name.upcase} ----- #
          can :read, #{class_name} if #{options[:auth_class].downcase}.role? :guest
          if #{options[:auth_class].downcase}.role? :user
            can [:read, :create], #{class_name}
            can [:update, :destroy], #{class_name}
          end
          if #{options[:auth_class].downcase}.role? :manager
            can [:read, :create, :update, :destroy], #{class_name}
          end

          FILE
        end
      end

      def add_seeds_db
        return unless options.seeds? and options[:seeds_elements].to_i > 0
        file = "db/seeds.rb"
        append_file file do
          items = []
          attributes.each do |attribute|
            items << attribute_to_hash(attribute)
          end
          row = "{ #{items.join(', ')} }"

          #TODO: to have different values for every row
          content = "#{CRLF}### Created by leosca controller generator ### #{CRLF}"
          attributes.each do |attribute|
            content << attribute_to_range(attribute)
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
        return unless activeadmin? and options[:activeadmin]
        #Rails::Generators.invoke("active_admin:resource", [singular_table_name])
        invoke "active_admin:resource", [singular_table_name]
        file = "app/admin/#{singular_table_name}.rb"

        inject_into_file file, :after => "ActiveAdmin.register #{class_name} do" do
          <<-FILE.gsub(/^          /, '')

            menu :if => proc{ can?(:read, #{class_name}) }

            permit_params do
              permitted = [#{attributes.map{|attr| ":#{attr.name}"}.join(', ')}]
              permitted
            end

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

      #def update_parent_controller
      #  return unless nested?
      #  file = "app/controllers/#{plural_last_parent}_controller.rb"
      #  inject_into_file file, :before => "  private" do
      #    <<-FILE.gsub(/^          /, '')
      #      def with_#{plural_table_name}
      #        @#{last_parent} = #{last_parent.classify}.find params[:#{last_parent}_id]
      #        @#{plural_table_name} = #{class_name}.where(:#{last_parent}_id => params[:#{last_parent}_id])
      #      end
      #
      #    FILE
      #  end if File.exists?(file)
      #end

    end
  end
end
