
module ActiveAdmin
  module Views
    module Pages

      #Custom footer
      #\lib\active_admin\views\pages\base.rb
      class Base < Arbre::HTML::Document
        private
        def build_footer
          div :id => "footer" do
            para "#{CONFIG[:application][:name]} #{Rails.env} #{CONFIG[:application][:version]} <%= Time.now.year %>.".html_safe
          end
        end

      end
    end

    #Avoid xml and json from download
    #\lib\active_admin\views\components\paginated_collection.rb
    #class PaginatedCollection
    #  def build_download_format_links(formats = [:csv])
    #    links = formats.collect do |format|
    #      link_to format.to_s.upcase, { :format => format}.merge(request.query_parameters.except(:commit, :format))
    #    end
    #    div :class => "download_links" do
		 #     text_node [I18n.t('active_admin.download'), links].flatten.join("&nbsp;").html_safe
    #    end
    #  end
    #end

  end

  #class Resource
  #  module ActionItems
  #    private
  #
  #    # Adds the default action items to each resource
  #    def add_default_action_items
  #      # New Link on all actions except :new and :show
  #      add_action_item :except => [:new, :show] do
  #        if controller.action_methods.include?('new') && can?(:create, eval(active_admin_config.resource_name.classify))
  #          link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
  #        end
  #      end
  #
  #      # Edit link on show
  #      add_action_item :only => :show do
  #        if controller.action_methods.include?('edit') && can?(:edit, resource)
  #          link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
  #        end
  #      end
  #
  #      # Destroy link on show
  #      add_action_item :only => :show do
  #        if controller.action_methods.include?("destroy") && can?(:destroy, resource)
  #          link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name),
  #            resource_path(resource),
  #            :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
  #        end
  #      end
  #    end
  #  end
  #end
end
