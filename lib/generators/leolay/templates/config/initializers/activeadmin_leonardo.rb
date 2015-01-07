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
  end
end
