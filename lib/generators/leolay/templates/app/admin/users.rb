ActiveAdmin.register <%= options[:auth_class].capitalize %> do
  menu :if => proc{ can?(:manage, <%= options[:auth_class].capitalize %>) }
  controller.authorize_resource

  config.sort_order = 'order asc'

  controller do
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
    #column :name
    column :email
    #column :login_ldap
    #column :gruppo, :sortable => :gruppo_id
    column :current_sign_in_at
    column :current_sign_in_ip
    #column :created_at
    default_actions
  end

  form :partial => "form"

  show do
    attributes_table do
      #row :gruppo do |<%= options[:auth_class].downcase %>|
      #  <%= options[:auth_class].downcase %>.gruppo ? <%= options[:auth_class].downcase %>.gruppo.try(:name) : "Unknown"
      #end
      #row :name
      row :email
      #row :login_ldap
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
      row :current_sign_in_ip
      row :roles do |user|
        user.roles.join ", "
      end
      row :created_at
      row :updated_at
    end

  end

  csv do
    column :email
    #column("Name") { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.name }
    #column("Group") { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.group.try(:name) }
    #column :login_ldap
    column(I18n.t('attributes.<%= options[:auth_class].downcase %>.roles')) { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.roles.join ", " }
    column(I18n.t('attributes.created_at')) { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.created_at.strftime("%d/%m/%Y") }
    column(I18n.t('attributes.<%= options[:auth_class].downcase %>.last_sign_in_at')) { |<%= options[:auth_class].downcase %>| <%= options[:auth_class].downcase %>.last_sign_in_at.strftime("%d/%m/%Y") if <%= options[:auth_class].downcase %>.last_sign_in_at }
  end
end
