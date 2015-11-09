require 'fileutils'

namespace :active do
  namespace :tests do

    desc "Prepare the environment passing rails version as argument or ENV['CI_RAILS']=x.x"
    task(:prepare, [:rails, :path]) do  |task_name, args|
      path = " --path=#{args[:path]}" if args[:path]
      ENV['CI_RAILS'] = args[:rails] if args[:rails]
      cmd = "bundle install#{path}"
      puts "#{cmd} with CI_RAILS: #{ENV['CI_RAILS']}"
      raise "Failed: #{cmd} #{ENV['CI_RAILS']}" unless system(cmd)
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
        puts "Starting commands for rails #{rails_version}..."
        root_path   = File.dirname(__FILE__)
        test_folder = "test"
        log_path    = File.join(File.dirname(root_path), test_folder, "#{task_name.to_s.gsub(/\:/,"_")}.log")

        Dir.mkdir(File.dirname(log_path)) unless File.exists? File.dirname(log_path)

        app_name = "TestApp_#{RUBY_VERSION.gsub(/\./,"")}_#{rails_version.gsub(/\./,"")}"

        commands = []
        commands << "delete #{File.join(test_folder,app_name)}"
        commands.concat [
            "bundle exec rails new #{test_folder}/#{app_name} -m active_template.rb test_mode --skip-bundle",
            [File.join(test_folder,app_name), "bundle install --path=mybundle_app",
                                              "bundle exec rails g leosca discussion name body:text",
                                              "bundle exec rails g leosca message discussion:references name body:text",
                                              "bundle exec rails g leosca foo name",
                                              "bundle exec rails d leosca foo name",
                                              "bundle exec rake db:migrate",
                                              "bundle exec rake db:seed"]
        ]
        commands << "delete #{File.join(test_folder,app_name)}"  unless inspection
        commands << "delete #{log_path}"  unless inspection

        puts "Dir.pwd #{Dir.pwd}"
        commands.each do |command|

          if command.is_a? Array
            puts "Cmd Dir.chdir #{command.first}"
            Dir.chdir command.shift do
              puts "Dir.pwd #{Dir.pwd}"
              command.each do |single_command|
                puts "Cmd #{single_command}"
                raise "Failed: #{command}" unless system("#{single_command}")  #>> #{log_path}
              end
            end
          elsif command.include? "delete"
            puts "Cmd #{command}"
            what = command.match(/delete\s(.+)/)[1]
            FileUtils.rm_rf what if File.exists? what
          else
            puts "Cmd #{command}"
            raise "Failed: #{command}" unless system("#{command} ") #>> #{log_path}
          end
        end
      rescue
        puts $!.message
        exit(9)
      end
    end

    desc "Tests all rails versions"
    task(:all, [:inspection, :rails_versions]) do  |task_name, args|
      rails_versions = args[:rails_versions] ? args[:rails_versions].split('-') : %w(3.2 4.2)
      puts "Rails versions to test: #{rails_versions.join(', ')}"
      rails_versions.each do |rails_version|
        puts "--- Start test with rails #{rails_version} ---"
        %w(Gemfile.lock).each{|file| File.delete file if File.exist? file}
        Rake::Task["active:tests:prepare"].execute(:rails => rails_version, :path => "mybundle_#{rails_version.gsub(/\./,"")}")
        Rake::Task["active:tests:newapp"].execute(:inspection => true)
        puts "--- End test with rails #{rails_version} ---"
      end
    end
  end
end