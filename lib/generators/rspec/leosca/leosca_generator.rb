require 'generators/rspec/scaffold/scaffold_generator'
require File.join(File.dirname(__FILE__), '../../active_leonardo')

module Rspec
  module Generators
    class LeoscaGenerator < ::Rspec::Generators::ScaffoldGenerator
      include ::ActiveLeonardo::Base
      include ::ActiveLeonardo::Leosca
      include ::ActiveLeonardo::Test
      #include ::ActiveLeonardo::Nested
      #include ::ActiveLeonardo::Nested::Test
      #puts 'Rspec:Generators:LeoscaGenerator'
      source_paths << File.expand_path('../templates', __FILE__)

      #Leonardo options
      class_option :remote, :type => :boolean, :default => true, :desc => "It checks ajax sections"
      class_option :under, :type => :string, :default => "", :banner => "brand/category", :desc => "Nested resources"
      class_option :activespace, :type => :string, :default => "admin", :banner => ":admin", :desc => "To nest a resource under namespace(s)"

      #Override
      def generate_controller_spec
        return unless options[:controller_specs]

        template 'controller_spec.rb',
          #File.join('spec/controllers', base_namespaces, controller_class_path, "#{controller_file_name}_controller_spec.rb")
          File.join('spec/controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb")

        template "#{options[:activespace]}/controller_spec.rb",
                 #File.join('spec/controllers', base_namespaces, controller_class_path, "#{controller_file_name}_controller_spec.rb")
                 File.join('spec/controllers', options[:activespace], controller_class_path, "#{controller_file_name}_controller_spec.rb")
      end

      #Override
      def generate_routing_spec
        return unless options[:routing_specs]

        template 'routing_spec.rb',
          #File.join('spec/routing', base_namespaces, controller_class_path, "#{controller_file_name}_routing_spec.rb")
          File.join('spec/routing', controller_class_path, "#{controller_file_name}_routing_spec.rb")

        template "#{options[:activespace]}/routing_spec.rb",
                 #File.join('spec/routing', base_namespaces, controller_class_path, "#{controller_file_name}_routing_spec.rb")
                 File.join('spec/routing', options[:activespace], controller_class_path, "#{controller_file_name}_routing_spec.rb")
      end

      hook_for :integration_tool, :as => :leointegration

      protected

        #Override
        #def copy_view(view)
        #  template "#{view}_spec.rb",
        #           File.join("spec/views", base_namespaces, controller_file_path, "#{view}.html.#{options[:template_engine]}_spec.rb")
        #end
    end
  end
end
