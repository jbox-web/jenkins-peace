require 'tty-table'
require 'thor'

module Jenkins
  module Peace
    class CLI < Thor

      desc 'infos', 'Display infos about this gem'

      def infos
        list = []
        Jenkins::Peace.infos.each do |key , value|
          list << [key.upcase, value]
        end

        say
        table = TTY::Table.new rows: list
        puts table.render(:basic, padding: [0, 2])
        say
      end


      desc 'latest', 'Display infos about the latest version of war file installed'

      def latest
        if Jenkins::Peace.latest_version
          say Jenkins::Peace.latest_version, :green
        else
          say 'No Jenkins war files installed', :yellow
        end
      end


      desc 'list', 'List war files installed'

      def list
        return say 'No Jenkins war files installed', :yellow if Jenkins::Peace.list.empty?

        list = []
        Jenkins::Peace.list.each do |war_file|
          installed = war_file.installed? ? green(war_file.installed?) : red(war_file.installed?)
          if war_file.latest_version?
            version = "latest (#{war_file.real_version})"
          else
            version = war_file.version
          end
          list << [green(version), war_file.location, war_file.classpath, installed]
        end

        table = TTY::Table.new header: [bold('Version'), bold('Location'), bold('Classpath'), bold('Installed')], rows: list
        puts table.render(:ascii, padding: [0, 2])
      end


      desc 'download <version>', 'Download war file corresponding to version passed in params'

      def download(version)
        war_file = Jenkins::Peace.build_war_file(version)
        if war_file.exists?
          yes_no_question('Overwrite existing file?') do
            Jenkins::Peace.download(version)
          end
        else
          Jenkins::Peace.download(version)
          say 'Done!', :green
        end
      end


      desc 'unpack <version>', 'Unpack war file corresponding to version passed in params'

      def unpack(version)
        war_file = Jenkins::Peace.build_war_file(version)
        return download_it_first! unless war_file.exists?
        if war_file.unpacked?
          yes_no_question('Overwrite existing file?') do
            Jenkins::Peace.unpack(version)
          end
        else
          Jenkins::Peace.unpack(version)
          say 'Done!', :green
        end
      end


      desc 'install <version>', 'Install war file corresponding to version passed in params (will download then unpack war file)'

      def install(version)
        war_file = Jenkins::Peace.build_war_file(version)
        if war_file.exists?
          yes_no_question('Overwrite existing file?') do
            Jenkins::Peace.install(version)
          end
        else
          Jenkins::Peace.install(version)
          say 'Done!', :green
        end
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

      end

    end
  end
end
