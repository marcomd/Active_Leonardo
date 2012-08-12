
module ActiveAdmin
  module Views
    #Integrate cancan in default_actions
    #\lib\active_admin\views\index_as_table.rb
    class IndexAsTable
      class IndexTableFor
        # Adds links to View, Edit and Delete
        def default_actions(options = {})
          options = {
              :name => "",
              :auth => nil
          }.merge(options)
          column options[:name] do |resource|
            links = ''.html_safe
            if controller.action_methods.include?('show') && (options[:auth] ? can?(:read, resource) : true)
              links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
            end
            if controller.action_methods.include?('edit') && (options[:auth] ? can?(:update, resource) : true)
              links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
            end
            if controller.action_methods.include?('destroy') && (options[:auth] ? can?(:update, resource) : true)
              links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
            end
            links
          end
        end
      end
    end
  end

  module ViewHelpers
    # lib/active_admin/view_helpers/auto_link_helper.rb
    def auto_link(resource, link_content = nil)
      content = link_content || display_name(resource)
      if can?(:read, resource) && registration = active_admin_resource_for(resource.class)
        begin
          content = link_to(content, send(registration.route_instance_path, resource))
        rescue
        end
      end
      content
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

    # lib/active_admin/resource/menu.rb
    module Menu
      # The :if block is evaluated by TabbedNavigation#display_item?
      def default_menu_options
        klass = resource_class # avoid variable capture
        super.merge(:if => proc{ can? :read, klass })
      end
    end
  end

  class ResourceController
    # lib/active_admin/resource_controller/collection.rb

    # The following doesn't work (see https://github.com/ryanb/cancan/pull/683):
    #
    # load_and_authorize_resource
    # skip_load_resource :only => :index
    #
    # If you don't skip loading on #index you will get the exception:
    #
    # "Collection is not a paginated scope. Set collection.page(params[:page]).per(10) before calling :paginated_collection."
    #
    # Add to your activeadmin file:
    #
    # controller.load_resource :except => :index
    # controller.authorize_resource

    # https://github.com/gregbell/active_admin/wiki/Enforce-CanCan-constraints
    # https://github.com/ryanb/cancan/blob/master/lib/cancan/controller_resource.rb#L80
    module Collection
      module BaseCollection
        def scoped_collection
          end_of_association_chain.accessible_by(current_ability)
        end
      end
    end
  end
end
