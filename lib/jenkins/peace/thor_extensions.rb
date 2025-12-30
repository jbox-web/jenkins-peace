# frozen_string_literal: true

module Jenkins
  module Peace
    module ThorExtensions
      def warn(message)
        say message, :yellow
      end

      def info(message)
        say message, :green
      end

      def green(string)
        set_color string, :green
      end

      def red(string)
        set_color string, :red
      end

      def bold(string)
        set_color string, :bold
      end

      def success_message
        info 'Done !'
      end

      def yes_no_question(question)
        answer = yes? question, :bold
        if answer
          yield if block_given?
          success_message
        else
          warn 'Canceled !'
        end
      end

      def download_it_first!
        warn "War file doesn't exist, you should install it first with : jenkins.peace install <version>"
        warn 'Exiting !'
      end

      def check_conflicts_and_call_method(method, version, check_method = :exists?) # rubocop:disable Metrics/MethodLength
        war_file = Jenkins::Peace.build_war_file(version)
        yield war_file if block_given?
        message = "#{method.capitalize}ing Jenkins war file version : '#{version}'"
        if war_file.send(check_method)
          yes_no_question('Overwrite existing file?') do
            info message
            Jenkins::Peace.send(method, version, true)
          end
        else
          info message
          Jenkins::Peace.send(method, version)
          success_message
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
