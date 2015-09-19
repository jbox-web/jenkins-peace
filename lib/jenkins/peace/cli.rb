require 'tty-table'
require 'thor'

module Jenkins
  module Peace
    class CLI < Thor

      desc 'infos', 'Display infos about this gem'

      def infos
        say
        table = TTY::Table.new rows: Jenkins::Peace.infos.to_a
        puts table.render(:basic, padding: [0, 2])
        say
      end


      desc 'latest', 'Display infos about the latest version of war file installed'

      def latest
        return say 'No Jenkins war files installed', :yellow unless Jenkins::Peace.latest_version
        say Jenkins::Peace.latest_version, :green
      end


      desc 'list', 'List war files installed'

      def list
        return say 'No Jenkins war files installed', :yellow if Jenkins::Peace.list.empty?
        table = TTY::Table.new header: formated_headers, rows: formated_war_files_list
        puts table.render(:ascii, padding: [0, 2])
      end


      desc 'download <version>', 'Download war file corresponding to version passed in params'

      def download(version)
        check_presence_and_call_method(:download, version)
      end


      desc 'unpack <version>', 'Unpack war file corresponding to version passed in params'

      def unpack(version)
        check_presence_and_call_method(:unpack, version, :unpacked?) do |war_file|
          return download_it_first! unless war_file.exists?
        end
      end


      desc 'install <version>', 'Install war file corresponding to version passed in params (will download then unpack war file)'

      def install(version)
        check_presence_and_call_method(:install, version)
      end


      desc 'remove <version>', 'Remove war file corresponding to version passed in params'

      def remove(version)
        Jenkins::Peace.remove(version)
        say 'Done!', :green
      end


      desc 'clean', 'Remove all war files'

      def clean
        yes_no_question('Are you sure?') do
          Jenkins::Peace.clean!
        end
      end


      desc 'server <version>', 'Start a server with the war file corresponding to version passed in params'

      method_option :home,    aliases: '-h', default: File.join(ENV['HOME'], '.jenkins', 'server'), type: :string, desc: 'Use this directory to store server data'
      method_option :port,    aliases: '-p', default: 3001,  type: :numeric, desc: 'Port for server (default 3001)'
      method_option :control, aliases: '-c', default: 3002,  type: :numeric, desc: 'Shutdown/Control port (default 3002)'
      method_option :daemon,  aliases: '-d', default: false, type: :boolean, desc: 'Daemonize'
      method_option :kill,    aliases: '-k', default: false, type: :boolean, desc: 'Kill'
      method_option :logfile, aliases: '-l', default: File.join(Dir.pwd, 'jenkins.log'), type: :string, desc: 'Redirect log messages to this file'

      def server(version)
        war_file = Jenkins::Peace.build_war_file(version)
        if war_file.exists?
          war_file.execute!(options)
        else
          download_it_first!
        end
      end


      no_commands do

        def green(string)
          set_color string, :green
        end


        def red(string)
          set_color string, :red
        end


        def bold(string)
          set_color string, :bold
        end


        def yes_no_question(question, &block)
          answer = yes? question, :bold
          if answer
            yield
            say 'Done!', :green
          else
            say 'Canceled', :yellow
          end
        end


        def download_it_first!
          say "War file doesn't exist, you should install it first with : jenkins.peace install <version>", :yellow
          say 'Exiting !', :yellow
        end


        def check_presence_and_call_method(method, version, check_method = :exists?, &block)
          war_file = Jenkins::Peace.build_war_file(version)
          yield war_file if block_given?
          if war_file.send(check_method)
            yes_no_question('Overwrite existing file?') do
              Jenkins::Peace.send(method, version)
            end
          else
            Jenkins::Peace.send(method, version)
            say 'Done!', :green
          end
        end


        def formated_war_files_list
          list = []
          Jenkins::Peace.list.each do |war_file|
            installed = war_file.installed? ? green(war_file.installed?) : red(war_file.installed?)
            version = war_file.latest_version? ? "latest (#{war_file.real_version})" : war_file.version
            list << [green(version), war_file.location, war_file.classpath, installed]
          end
          list
        end


        def formated_headers
          [bold('Version'), bold('Location'), bold('Classpath'), bold('Installed')]
        end

      end

    end
  end
end
