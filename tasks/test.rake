require 'fileutils'

namespace :active do
  namespace :tests do
    desc "Prepare the environment passing rails version as argument or ENV['CI_RAILS']=x.x"
    task(:prepare, [:rails, :path]) do  |task_name, args|
      path = " --path=#{args[:path]}" if args[:path]
      ENV['CI_RAILS'] = args[:rails] if args[:rails]
      system "bundle install#{path}"
    end

    desc "Creates a test rails app for the specs to run against"
    task(:newapp, [:inspection, :rails]) do  |task_name, args|
      inspection  = case args[:inspection]
                      when 'false', nil then
                        false
                      else
                        true
                    end

      rails_version = args[:rails] || ENV['CI_RAILS']
      raise "Please specify rails version as argument or ENV['CI_RAILS']" unless rails_version
      begin
        root_path   = File.dirname(__FILE__)
        test_folder = "test"
        log_path    = File.join(File.dirname(root_path), test_folder, "#{task_name.to_s.gsub(/\:/,"_")}.log")

        Dir.mkdir(File.dirname(log_path)) unless File.exists? File.dirname(log_path)

        app_name = "TestApp_#{RUBY_VERSION.gsub(/\./,"")}_#{rails_version.gsub(/\./,"")}"

        commands = [
            "bundle exec rails new #{test_folder}/#{app_name} -m active_template.rb test_mode",
            [File.join(test_folder,app_name), "bundle install --path=mybundle",
                                              "bundle exec rails g leosca discussion name body:text",
                                              "bundle exec rails g leosca message discussion:references name body:text",
                                              "bundle exec rake db:migrate",
                                              "bundle exec rake db:seed"]
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

    desc "Tests all rails versions"
    task(:all, [:inspection]) do  |task_name, args|
      ['3.2', '4.0'].each do |rails_version|
        Rake::Task["active:tests:prepare"].invoke(rails_version, "mybundle_#{rails_version.gsub(/\./,"")}")
        Rake::Task["active:tests:newapp"].invoke('inspection')
      end
    end
  end
end