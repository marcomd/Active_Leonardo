ActiveAdmin.register <%= options[:auth_class] %> do
  <%- if options.authorization? -%>
  menu :if => proc{ can?(:manage, <%= options[:auth_class] %>) }
  <%- end -%>
  config.sort_order = 'email_asc'

  controller do
    <%- if options.authorization? -%>
    load_resource :except => :index
    authorize_resource
    <%- end -%>
    def update
      unless params[:<%= options[:auth_class].downcase %>]['password'] && params[:<%= options[:auth_class].downcase %>]['password'].size > 0
        params[:<%= options[:auth_class].downcase %>].delete 'password'
        params[:<%= options[:auth_class].downcase %>].delete 'password_confirmation'
      end
      super do
        #do something
      end
    end
  end

  index do
    id_column
    column :email
    #column :group, :sortable => :group_id
    <%- if options.authorization? -%>
    column :roles do |<%= options[:auth_class].downcase %>|
      <%= options[:auth_class].downcase %>.roles.join ", "
    end
    <%- end -%>
    column :current_sign_in_at
    column :current_sign_in_ip
    column :created_at
    default_actions
  end

  form do |f|
    <%- if options.authorization? -%>
    input_roles = "<li>" <<
        f.label(:roles) <<
        <%= options[:auth_class] %>::ROLES.map{|role| check_box_tag("<%= options[:auth_class].downcase %>[roles][]", role, f.object.roles.include?(role)) << ' ' << role.humanize.html_safe }.join(" ") <<
        hidden_field_tag("<%= options[:auth_class].downcase %>[roles][]") <<
        "</li>"
    <%- end -%>
    f.inputs "Account" do
      f.input :email
      f.input :password
      f.input(:password_confirmation) <%= "<< input_roles.html_safe" if options.authorization? %>
          
    end
    f.buttons
  end

  show do
    attributes_table do
      row :email
      #row :group
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
      row :current_sign_in_ip
      <%- if options.authorization? -%>
      row :roles do |<%= options[:auth_class].downcase %>|
        <%= options[:auth_class].downcase %>.roles.join ", "
      end
      <%- end -%>
      row :created_at
      row :updated_at
    end
  end

  csv do
    column :email
    #column("Name") { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.name }
    #column("Group") { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.group.try(:name) }
    <%- if options.authorization? -%>
    column(I18n.t('attributes.<%= options[:auth_class].downcase %>.roles')) { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.roles.join ", " }
    <%- end -%>
    column(I18n.t('attributes.created_at')) { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.created_at.strftime("%d/%m/%Y") }
    column(I18n.t('attributes.<%= options[:auth_class].downcase %>.last_sign_in_at')) { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.last_sign_in_at.strftime("%d/%m/%Y") if <%= options[:auth_class].downcase %>.last_sign_in_at }
  end
end
