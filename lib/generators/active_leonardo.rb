module ActiveLeonardo
  module Base
    protected
    def authorization_file
      "app/models/ability.rb"
    end
    def authorization?
      File.exists? authorization_file
    end
    def authentication_file auth_class="User"
      "app/models/#{auth_class.downcase}.rb"
    end
    def authentication? auth_class="User"
      return true if File.exists? authentication_file(auth_class)
      File.exists? "config/initializers/devise.rb"
    end
    def activeadmin_file
      "config/initializers/active_admin.rb"
    end
    def activeadmin?
      File.exists? activeadmin_file
    end
    def auth_class
      return unless options[:auth_class]
      options[:auth_class].classify
    end
  end

  module Leosca

    module Seed
      protected
      def attribute_to_hash(attribute)
        name = case attribute.type
                 when :references, :belongs_to then ":#{attribute.name}_id"
                 else                               ":#{attribute.name}"
               end
        value = case attribute.type
                  when :boolean                 then "true"
                  when :integer                 then "#"
                  when :float, :decimal         then "#.46"
                  when :references, :belongs_to then "rand(#{attribute.name}_from..#{attribute.name}_to)"
                  when :date                    then "#{Time.now.strftime("%Y-%m-%d 00:00:00.000")}".inspect
                  when :datetime                then "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.000")}".inspect
                  when :time, :timestamp        then "#{Time.now.strftime("%H:%M:%S.000")}".inspect
                  else                               "#{attribute.name.titleize}\#".inspect
                end
        " #{name} => #{value}"
      end
      def attribute_to_range(attribute)
        case attribute.type
          when :references, :belongs_to then  "#{attribute.name}_from = #{attribute.name.classify}.first.id; #{attribute.name}_to = #{attribute.name.classify}.last.id#{CRLF}"
          else                                ""
        end
      end
      def attributes_accessible(attributes, class_name)
        selected = attributes.select {|attribute| [:references, :belongs_to].include?(attribute.type) ? true : false }
        if selected.empty?
          ""
        else
          "#{class_name}.attr_accessible " <<
              selected.map{|attribute| ":#{attribute.name}_id"}.join(', ') <<
              CRLF
        end
      end
    end

    module Rspec
      protected
      def attribute_to_factories(attribute)
        spaces = 34
        space_association = " " * (spaces-11).abs
        space_sequence = " " * (spaces-attribute.name.size-11).abs
        space_other = " " * (spaces-attribute.name.size).abs
        name = case attribute.type
                 when :references, :belongs_to   then "#{singular_table_name[0..0]}.association#{space_association}"
                 when :boolean, :datetime, :time, :timestamp
                 then "#{singular_table_name[0..0]}.#{attribute.name}#{space_other}"
                 else                                 "#{singular_table_name[0..0]}.sequence(:#{attribute.name})#{space_sequence}"
               end
        value = case attribute.type
                  when :boolean                 then "true"
                  when :integer                 then "{|n| n }"
                  when :float, :decimal         then "{|n| n }"
                  when :references, :belongs_to then ":#{attribute.name}"
                  when :date                    then "{|n| n.month.ago }"
                  when :datetime                then "#{Time.now.strftime("%Y-%m-%d %H:%M:%S.000")}".inspect
                  when :time, :timestamp        then "#{Time.now.strftime("%H:%M:%S.000")}".inspect
                  else                               "{|n| \"#{attribute.name.titleize}\#{n}\" }"
                end
        "    #{name}#{value}"
      end
      def attribute_to_requests(attribute, object_id=nil)
        object_id ||= "#{singular_table_name}_#{attribute.name}"
        object_id = object_id.gsub('#', "\#{#{singular_table_name}.id}").gsub('name', attribute.name)
        case attribute.type
          when :boolean                 then "check \"#{object_id}\" if #{singular_table_name}.#{attribute.name}"
          when :references, :belongs_to then "select #{singular_table_name}.#{attribute.name}.name, :from => \"#{object_id}_id\""
          when :datetime, :time, :timestamp
          then ""
          when :date                    then "fill_in \"#{object_id}\", :with => #{singular_table_name}.#{attribute.name}.strftime('%d-%m-%Y')"
          else                               "fill_in \"#{object_id}\", :with => #{singular_table_name}.#{attribute.name}"
        end
      end

      def get_attr_to_match(view=:list)
        #attributes.each do |attribute|
        #  case attribute.type
        #  when :string, :text then
        #    return  "have_content(#{singular_table_name}.#{attribute.name})",
        #            "have_no_content(#{singular_table_name}.#{attribute.name})"
        #  end
        #end
        attr = get_attr_to_check(view)
        return  "have_content(#{singular_table_name}.#{attr})",
            "have_no_content(#{singular_table_name}.#{attr})" if attr

        #If there are not string or text attributes
        case view
          when :list
            return  "have_xpath('//table/tbody/tr')", "have_no_xpath('//table/tbody/tr')"
          when :show
            return  "have_xpath('//table/tbody/tr')", "have_no_xpath('//table/tbody/tr')"
        end
      end
      def get_attr_to_check(view=:list)
        case view
          when :something
          else
            attributes.each{|a| case a.type when :string, :text then return a.name end}
            attributes.each{|a| case a.type when :references, :belongs_to, :datetime then nil else return a.name end}
        end
      end
      def fill_form_with_values(object_id=nil)
        items = []
        attributes.each{|a|items << "        #{attribute_to_requests(a, object_id)}"}
        items
      end

    end

    module Locale
      protected
      def attributes_to_list(attributes, file_name)
        content = "#{CRLF}      #{file_name}:#{CRLF}"
        attributes.each do |attribute|
          content << "        #{attribute.name}: \"#{attribute.name.humanize}\"#{CRLF}"
        end
        content
      end

      def attributes_to_hints(attributes, file_name)
        content = "#{CRLF}      #{file_name}:#{CRLF}"
        attributes.each do |attribute|
          attribute_name_for_desc = attribute.name.humanize.downcase
          case attribute.type
            when :integer, :decimal, :float
              content << "        #{attribute.name}: \"Fill the #{attribute_name_for_desc} with a#{"n" if attribute.type == :integer} #{attribute.type.to_s} number\"#{CRLF}"
            when :boolean
              content << "        #{attribute.name}: \"Select if this #{file_name} should be #{attribute_name_for_desc} or not\"#{CRLF}"
            when :string
              content << "        #{attribute.name}: \"Choose a good #{attribute_name_for_desc} for this #{file_name}\"#{CRLF}"
            when :text
              content << "        #{attribute.name}: \"Write something as #{attribute_name_for_desc}\"#{CRLF}"
            when :date, :datetime, :time, :timestamp
              content << "        #{attribute.name}: \"Choose a #{attribute.type.to_s} for #{attribute_name_for_desc}\"#{CRLF}"
            else
              content << "        #{attribute.name}: \"Choose the #{attribute_name_for_desc}\"#{CRLF}"
          end
        end
        content
      end

    end

    module Activeadmin
      ACTIVEADMIN_INDENT_SPACES = 25
      def attributes_to_aa_permit_params(attributes)
        attributes.map do |attr|
          case attr.type
            when :references, :belongs_to then  ":#{attr.name}_id"
            else                                ":#{attr.name}"
          end
        end.join(', ')
      end
      def attributes_to_aa_index(attributes)
        attributes.map do |attr|
          case attr.type
            when :references, :belongs_to then  "  #  column(:#{attr.name})"
            when :boolean                 then  "  #  column(:#{attr.name})#{' ' * (ACTIVEADMIN_INDENT_SPACES-attr.name.size).abs}{|#{singular_table_name}| status_tag #{singular_table_name}.#{attr.name}}"
            else                                "  #  column(:#{attr.name})#{' ' * (ACTIVEADMIN_INDENT_SPACES-attr.name.size).abs}{|#{singular_table_name}| #{singular_table_name}.#{attr.name}}"
          end
        end.join("\n")
      end
      def attributes_to_aa_show(attributes)
        attributes.map do |attr|
          case attr.type
            when :references, :belongs_to then  "  #    row(:#{attr.name})"
            when :boolean                 then  "  #    row(:#{attr.name})#{' ' * (ACTIVEADMIN_INDENT_SPACES-attr.name.size).abs}{|#{singular_table_name}| status_tag #{singular_table_name}.#{attr.name}}"
            else                                "  #    row(:#{attr.name})#{' ' * (ACTIVEADMIN_INDENT_SPACES-attr.name.size).abs}{|#{singular_table_name}| #{singular_table_name}.#{attr.name}}"
          end
        end.join("\n")
      end
      def attributes_to_aa_filter(attributes)
        attributes.map{|attr| "  #filter :#{attr.name}"}.join("\n")
      end
      def attributes_to_aa_form(attributes)
        attributes.map do |attr|
          case attr.type
            when :date                then  "  #    f.input :#{attr.name}, as: :datepicker, input_html: { class: 'calendar' }"
            else                            "  #    f.input :#{attr.name}"
          end
        end.join("\n")
      end
      def attributes_to_aa_csv(attributes)
        attributes.map{|attr| "  #  column(:#{attr.name})#{' ' * (ACTIVEADMIN_INDENT_SPACES-attr.name.size).abs}{|#{singular_table_name}| #{singular_table_name}.#{attr.name}}"}.join("\n")
      end
    end
  end

end