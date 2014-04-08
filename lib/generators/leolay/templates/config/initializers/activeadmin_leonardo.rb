module ActiveAdmin
  module Views
    module Pages
      #Custom footer
      #\lib\active_admin\views\pages\base.rb
      class Base < Arbre::HTML::Document
        private
        def build_footer
          div :id => "footer" do
            para "#{CONFIG[:application][:name]} #{Rails.env} #{CONFIG[:application][:version]}, <%= Time.now.year %>.".html_safe
            para style_image_tag "logo.png"
          end
        end

      end
    end

    #Per integrare default_actions con cancan
    #\lib\active_admin\views\index_as_table.rb
    class IndexAsTable
      class IndexTableFor
        # Adds links to View, Edit and Delete
        def default_actions(options = {})
          options = {
              :name => "",
              :auth => true
          }.merge(options)
          column options[:name] do |resource|
            links = ''.html_safe
            if controller.action_methods.include?('show') && (options[:auth] ? can?(:read, resource) : true)
              links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
            end
            if controller.action_methods.include?('edit') && (options[:auth] ? can?(:update, resource) : true)
              links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
            end
            if controller.action_methods.include?('destroy') && (options[:auth] ? can?(:destroy, resource) : true)
              links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
            end
            links
          end
        end
      end
    end
  end
  class Resource
    module ActionItems
      private

      # Adds the default action items to each resource
      def add_default_action_items
        # New Link on all actions except :new and :show
        add_action_item :except => [:new, :show] do
          if controller.action_methods.include?('new') && can?(:create, active_admin_config.resource_class)
            link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
          end
        end

        # Edit link on show
        add_action_item :only => :show do
          if controller.action_methods.include?('edit') && can?(:edit, resource)
            link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
          end
        end

        # Destroy link on show
        add_action_item :only => :show do
          if controller.action_methods.include?("destroy") && can?(:destroy, resource)
            link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name),
                    resource_path(resource),
                    :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
          end
        end
      end
    end
  end
end
