require 'fileutils'

namespace :active do
  namespace :tests do
    desc "Creates a test rails app for the specs to run against"
    task(:newapp, [:inspection]) do  |task_name, args|
      inspection  = case args[:inspection]
                      when 'false', nil then
                        false
                      else
                        true
                    end

      begin
      root_path   = File.dirname(__FILE__)
      test_folder = "test"
      log_path    = File.join(File.dirname(root_path), test_folder, "#{task_name.to_s.gsub(/\:/,"_")}.log")

      Dir.mkdir(File.dirname(log_path)) unless File.exists? File.dirname(log_path)

      app_name = "TestApp_#{RUBY_VERSION.gsub(/\./,"")}"

      commands = [
          "bundle exec rails new #{test_folder}/#{app_name} -m active_template.rb test_mode",
          [File.join(test_folder,app_name), "bundle exec rails g leosca post name"]
      ]
      commands << "delete #{File.join(test_folder,app_name)}"  unless inspection
      commands << "delete #{log_path}"  unless inspection

        commands.each do |command|
          puts "Cmd #{command}"
          if command.is_a? Array
            Dir.chdir command.shift do
              command.each do |single_command|
                raise "Failed: #{command}" unless system("#{single_command}")  #>> #{log_path}
              end
            end
          elsif command.include? "delete"
            FileUtils.rm_rf command.match(/delete\s(.+)/)[1]
          else
            raise "Failed: #{command}" unless system("#{command} ") #>> #{log_path}
          end
        end
      rescue
        puts $!.message
        exit(9)
      end
    end
  end
end