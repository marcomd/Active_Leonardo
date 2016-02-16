module Leosca
  module Generators
    class Thor
      attr_reader :_initializer
    end
    class MassiveGenerator < Rails::Generators::Base
      source_root File.expand_path('../../', __FILE__)
      class_option :seeds,          :type => :boolean,  :default => true,                                       :desc => "Create seeds to run with rake db:seed"
      class_option :seeds_elements, :type => :string,   :default => "30",   :banner => "NUMBER",                :desc => "Choose seeds elements"
      class_option :auth_class,     :type => :string,   :default => 'User',                                     :desc => "Set the authentication class name"
      class_option :activeadmin,    :type => :boolean,  :default => true,                                       :desc => "Add code to manage activeadmin gem"

      def scaffold
        # puts "args #{self.args}"
        # puts "options #{self.options}"
         puts "behavior #{self.behavior}"
        # puts "shell #{self.shell}"
        # puts "in_group #{self.instance_variable_get(:@in_group)}"
        # puts "_invocations #{self.instance_variable_get(:@_invocations)}"
        # puts "_initializer #{self.instance_variable_get(:@_initializer)}"
        # return nil

        num_ok, num_ko, num_discards = 0, 0, 0
        time = Time.now
        begin
          filename = "scaffold.txt"
          raise "Write all your resources into #{filename} in the app root" unless File.exist? filename
          puts "#{time.strftime("%H:%M:%S")} - Starting generations, please wait..."
          puts "-" * 45
          File.open(filename, "r") do |file|
            while (line = file.gets)
              begin
                case generate line
                  when true
                    num_ok += 1
                  when false
                    num_ko += 1
                  when nil
                    num_discards += 1
                end
              rescue
                num_ko += 1
                puts "*** #{$!.message} ***"
              end
            end
          end
        rescue
          puts "Oh oh, generation interrupted! #{$!.message} ***"
        end

        puts "-" * 45
        puts "Generations started at #{time.strftime("%H:%M:%S")}"
        puts "#{Time.now.strftime("%H:%M:%S")} - generations ended in #{(Time.now-time).to_i} second(s)"
        puts "#{num_ok} generation#{'s' unless num_ok == 1} executed"
        puts "#{num_discards} line#{'s' unless num_discards == 1} discarded (comments etc.)" if num_discards>0
        puts "#{num_ko} generation#{'s' unless num_ko == 1} *** FAILED ***" if num_ko>0
        puts "-" * 45
      end

      private

      def generate line
        regexp_rails_g = 'rails [dg][a-z]*\s'
        line.strip!
        unless line.empty? or line[0..0]=="#"
          if /#{regexp_rails_g}/i === line
            # Will invoke a custom generator specified in the line
            line.sub! /#{regexp_rails_g}/i, ''
            generator_name = line.match(/\w+/).to_s
            line.sub! /#{generator_name}/, ''
            line.strip!
          else
            generator_name = 'leosca'
          end
          raise "Generator not recognized! #{line[0..20]}..." if /^rails/ === line
          puts "#{generator_name} #{line}"
          Rails::Generators.invoke generator_name, line.split(' '), :behavior => self.behavior
          true
        else
          nil
        end
      end

    end
  end
end