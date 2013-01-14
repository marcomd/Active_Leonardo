require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe <%= options[:activespace].classify %>::<%= controller_class_name %>Controller do

<% unless options[:singleton] -%>
  describe "GET index" do
    it "assigns all <%= table_name.pluralize %> as @<%= table_name.pluralize %>" do
      <%= "login_controller_as(:user)" if authentication? %>
      <%= file_name %> = Factory(:<%= file_name %>)
      get :index
      assigns(:<%= table_name %>).should eq([<%= file_name %>])
    end
  end

<% end -%>
  describe "GET show" do
    it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
      <%= "login_controller_as(:user)" if authentication? %>
      <%= file_name %> = Factory(:<%= file_name %>)
      get :show, :id => <%= file_name %>.id.to_s
      assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
    end
  end

  describe "GET new" do
    it "assigns a new <%= ns_file_name %> as @<%= ns_file_name %>" do
      <%= "login_controller_as(:user)" if authentication? %>
      get :new
      assigns(:<%= ns_file_name %>).should be_a_new(<%= class_name %>)
    end
  end

  describe "GET edit" do
    it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
      <%= "login_controller_as(:user)" if authentication? %>
      <%= file_name %> = Factory(:<%= file_name %>)
      get :edit, :id => <%= file_name %>.id.to_s
      assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new <%= class_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        expect {
          post :create, :<%= ns_file_name %> => Factory.attributes_for(:<%= file_name %>)
        }.to change(<%= class_name %>, :count).by(1)
      end

      it "assigns a newly created <%= ns_file_name %> as @<%= ns_file_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        post :create, :<%= ns_file_name %> => Factory.attributes_for(:<%= file_name %>)
        assigns(:<%= ns_file_name %>).should be_a(<%= class_name %>)
        assigns(:<%= ns_file_name %>).should be_persisted
      end

      it "redirects to the created <%= ns_file_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        post :create, :<%= ns_file_name %> => Factory.attributes_for(:<%= file_name %>)
        response.should redirect_to(<%= show_resource_path_test "#{class_name}.last" %>)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved <%= ns_file_name %> as @<%= ns_file_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        post :create, :<%= ns_file_name %> => {}
        assigns(:<%= ns_file_name %>).should be_a_new(<%= class_name %>)
      end

      it "re-renders the 'new' template" do
        <%= "login_controller_as(:user)" if authentication? %>
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        post :create, :<%= ns_file_name %> => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested <%= ns_file_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        # Assuming there are no other <%= table_name %> in the database, this
        # specifies that the <%= class_name %> created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        <%= class_name %>.any_instance.should_receive(:update_attributes).with(Factory.attributes_for(:<%= file_name %>))
        put :update, :id => <%= file_name %>.id, :<%= ns_file_name %> => Factory.attributes_for(:<%= file_name %>)
      end

      it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        put :update, :id => <%= file_name %>.id, :<%= ns_file_name %> => Factory.attributes_for(:<%= file_name %>)
        assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
      end

      it "redirects to the <%= ns_file_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        put :update, :id => <%= file_name %>.id, :<%= ns_file_name %> => Factory.attributes_for(:<%= file_name %>)
        response.should redirect_to(<%= show_resource_path_test %>)
      end
    end

    describe "with invalid params" do
      it "assigns the <%= ns_file_name %> as @<%= ns_file_name %>" do
        <%= "login_controller_as(:user)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        put :update, :id => <%= file_name %>.id.to_s, :<%= ns_file_name %> => {}
        assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
      end

      it "re-renders the 'edit' template" do
        <%= "login_controller_as(:user)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        put :update, :id => <%= file_name %>.id.to_s, :<%= ns_file_name %> => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    describe "with authorization" do
      it "destroys the requested <%= ns_file_name %>" do
        <%= "login_controller_as(:user_manager)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        expect {
          delete :destroy, :id => <%= file_name %>.id.to_s
        }.to change(<%= class_name %>, :count).by(-1)
      end

      it "redirects to the <%= table_name %> list" do
        <%= "login_controller_as(:user_manager)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        delete :destroy, :id => <%= file_name %>.id.to_s
        response.should redirect_to(<%= list_resources_path_test %>)
      end
    end
    <%- if authorization? -%>
    describe "without authorization" do
      it "destroys the requested <%= ns_file_name %>" do
        <%= "login_controller_as(:user_guest)" if authentication? %>
        <%= file_name %> = Factory(:<%= file_name %>)
        expect {
          delete :destroy, :id => <%= file_name %>.id.to_s
        }.to change(<%= class_name %>, :count).by(0)
      end
    end
    <%- end -%>
  end

end