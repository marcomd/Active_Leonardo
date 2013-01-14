require 'spec_helper'
<%- check_attr_to_have, check_attr_to_not_have = get_attr_to_match -%>

feature "<%= options[:activespace].classify %>::<%= class_name.pluralize %>" do
    scenario "displays <%= plural_table_name %>" do
      <%= singular_table_name %> = Factory(:<%= singular_table_name %>)
      visit <%= list_resources_path_test %>
      <%= "login_view_as(:user_guest)" if authentication? -%>
      #save_and_open_page #uncomment to debug
      page.should <%= check_attr_to_have %>
      assert page.find("tr#<%= singular_table_name %>_#{<%= singular_table_name %>.id}").visible?
    end

    scenario "creates a new <%= singular_table_name %>" do
      <%= singular_table_name %> = Factory.build(:<%= singular_table_name %>)
      visit <%= new_resource_path_test %>
      <%= "login_view_as(:user_admin)" if authentication? %>
<%= fill_form_with_values.join(CRLF) %>
      click_button "Create #{I18n.t('models.<%= singular_table_name %>')}"
      #save_and_open_page #uncomment to debug
      page.should have_content(I18n.t(:created, :model => I18n.t('models.<%= singular_table_name %>')))
      page.should <%= check_attr_to_have %>
    end

    scenario "edit a <%= singular_table_name %>" do
      <%= singular_table_name %> = Factory(:<%= singular_table_name %>)
      visit <%= list_resources_path_test %>
      <%= "login_view_as(:user_manager)" if authentication? -%>
      #save_and_open_page #uncomment to debug
      page.should <%= check_attr_to_have %>
      assert page.find("tr#<%= singular_table_name %>_#{<%= singular_table_name %>.id}").visible?
      check("check#{<%= singular_table_name %>.id}")
      click_link I18n.t(:edit)
      page.should have_content(I18n.t(:edit))
<%= fill_form_with_values("#{plural_table_name}_#_name").join(CRLF) %>
      click_button I18n.t(:submit)
      page.should have_content(I18n.t(:show))
    end

    scenario "destroy one <%= singular_table_name %>" do
      <%= singular_table_name %> = Factory(:<%= singular_table_name %>)
      visit <%= list_resources_path_test %>
      <%= "login_view_as(:user_manager)" if authentication? -%>
      #save_and_open_page #uncomment to debug
      page.should <%= check_attr_to_have %>
      assert page.find("tr#<%= singular_table_name %>_#{<%= singular_table_name %>.id}").visible?
      click_link I18n.t(:delete)
      #page.should have_no_content("<%= singular_table_name %>#{<%= singular_table_name %>.id}")
      assert_not page.find("tr#<%= singular_table_name %>_#{<%= singular_table_name %>.id}")
    end

    scenario "destroy several <%= plural_table_name %>", :js => true do
      <%= plural_table_name %> = FactoryGirl.create_list(:<%= singular_table_name %>, 2)
      visit <%= list_resources_path_test %>
      <%= "login_view_as(:user_manager)" if authentication? -%>
      #save_and_open_page #uncomment to debug
      <%= plural_table_name %>.each do |<%= singular_table_name %>|
        page.should <%= check_attr_to_have %>
        assert page.find("tr#<%= singular_table_name %>_#{<%= singular_table_name %>.id}").visible?
        check "batch_action_item_#{<%= singular_table_name %>.id}"
      end
      click_link I18n.t('active_admin.batch_actions.action_label', :title => 'active_admin.batch_actions.labels.destroy')
      <%= plural_table_name %>.each do |<%= singular_table_name %>|
        page.should_not <%= check_attr_to_have %>
      end
    end
end
