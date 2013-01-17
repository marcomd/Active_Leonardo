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
end
