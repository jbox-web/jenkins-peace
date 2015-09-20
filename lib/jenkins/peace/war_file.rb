require 'socket'

module Jenkins
  module Peace
    class WarFile

      JENKINS_VERSION_REGEX = /jenkins-core-(1\.\d{3}).jar/

      attr_reader :version
      attr_reader :lib_path
      attr_reader :base_path
      attr_reader :base_url
      attr_reader :server_path
      attr_reader :logger

      attr_reader :file_name
      attr_reader :base_dir
      attr_reader :lib_dir
      attr_reader :klass_path
      attr_reader :plugins_path
      attr_reader :location
      attr_reader :url


      def initialize(version, opts = {})
        @version      = version
        @lib_path     = opts.fetch(:lib_path, '')
        @base_path    = opts.fetch(:base_path, '')
        @base_url     = opts.fetch(:base_url, '')
        @server_path  = opts.fetch(:server_path, '')
        @logger       = opts.fetch(:logger, $stdout)

        @file_name    = 'jenkins.war'
        @base_dir     = File.join(base_path, version)
        @lib_dir      = File.join(lib_path, version)
        @klass_path   = File.join(lib_dir, '**/*.jar')
        @plugins_path = File.join(lib_dir, 'WEB-INF', 'plugins')
        @location     = File.join(base_dir, file_name)
        @url          = File.join(base_url, version, file_name)
      end


      def latest_version?
        version == 'latest'
      end


      def real_version
        return version unless latest_version?
        klass = find_core_librairy
        klass.nil? ? nil : klass.match(JENKINS_VERSION_REGEX)[1]
      end


      def classpath
        File.join(lib_dir, 'WEB-INF', 'lib', "jenkins-core-#{real_version}.jar")
      end


      def exists?
        File.exists?(location)
      end


      def unpacked?
        File.exists?(lib_dir) && File.exists?(classpath)
      end


      def installed?
        exists? && unpacked?
      end


      def download!
        FileUtils.mkdir_p base_dir
        fetch_content(url, location)
      end


      def install!
        download!
        unpack!
      end


      def remove!
        FileUtils.rm_rf base_dir
        FileUtils.rm_rf lib_dir
      end


      def unpack!
        FileUtils.mkdir_p(lib_dir)
        execute_command("cd #{lib_dir} && jar xvf #{location}")
      end


      def start!(options = {})
        control = options.fetch(:control, 3002).to_i
        kill    = options.fetch(:kill, false)

        if kill
          TCPSocket.open('localhost', control) { |sock| sock.write('0') }
        else
          command = build_command_line(options)
          exec(*command)
        end
      end


      def build_command_line(options = {})
        home    = options.fetch(:home, server_path)
        port    = options.fetch(:port, 3001).to_i
        control = options.fetch(:control, 3002).to_i
        daemon  = options.fetch(:daemon, false)
        logfile = options.fetch(logfile, nil)

        java_tmp = File.join(home, 'javatmp')
        FileUtils.mkdir_p java_tmp

        ENV['HUDSON_HOME'] = home
        cmd = ['java', "-Djava.io.tmpdir=#{java_tmp}", '-jar', location]
        cmd << '--daemon' if daemon
        cmd << "--httpPort=#{port}"
        cmd << "--controlPort=#{control}"
        cmd << "--logfile=#{File.expand_path(logfile)}" if logfile
        cmd
      end


      private


        def execute_command(command)
          `#{command}`
        end


        def fetch_content(url, target_file, limit = 10)
          ContentDownloader.new(target_file, logger).download(url)
        end


        def find_core_librairy
          Dir[File.join(lib_dir, 'WEB-INF', 'lib', '*.jar')].select { |f| f =~ JENKINS_VERSION_REGEX }.first
        end

    end
  end
end
