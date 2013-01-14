require 'spec_helper'

feature "<%= class_name.pluralize %>" do
    scenario "When visit the index i should see some <%= plural_table_name %>" do
      # Write some real scenario
      visit <%= index_helper %>_path
      response.status.should be(200)
    end
end
