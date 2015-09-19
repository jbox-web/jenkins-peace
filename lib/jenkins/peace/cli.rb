require 'tty-table'
require 'thor'

module Jenkins
  module Peace
    class CLI < Thor

      include Jenkins::Peace::ThorExtensions

      desc 'infos', 'Display infos about this gem'

      def infos
        say
        table = TTY::Table.new rows: Jenkins::Peace.infos.to_a
        puts table.render(:basic, padding: [0, 2])
        say
      end


      desc 'latest', 'Display infos about the latest version of war file installed'

      def latest
        return warn 'No Jenkins war files installed' unless Jenkins::Peace.latest_version
        info Jenkins::Peace.latest_version
      end


      desc 'list', 'List war files installed'

      def list
        return warn 'No Jenkins war files installed' if Jenkins::Peace.list.empty?
        table = TTY::Table.new header: formated_headers, rows: formated_war_files_list
        puts table.render(:ascii, padding: [0, 2])
      end


      desc 'download <version>', 'Download war file corresponding to version passed in params'

      def download(version)
        check_conflicts_and_call_method(:download, version)
      end


      desc 'unpack <version>', 'Unpack war file corresponding to version passed in params'

      def unpack(version)
        check_conflicts_and_call_method(:unpack, version, :unpacked?) do |war_file|
          return download_it_first! unless war_file.exists?
        end
      end


      desc 'install <version>', 'Install war file corresponding to version passed in params (will download then unpack war file)'

      def install(version)
        check_conflicts_and_call_method(:install, version)
      end


      desc 'remove <version>', 'Remove war file corresponding to version passed in params'

      def remove(version)
        Jenkins::Peace.remove(version)
        success_message
      end


      desc 'clean', 'Remove all war files'

      def clean
        yes_no_question('Are you sure?') { Jenkins::Peace.clean! }
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
        war_file.exists? ? war_file.start!(options) : download_it_first!
      end

    end
  end
end
