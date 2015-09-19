require 'pathname'

module Jenkins
  module Peace
    extend self

    def jenkins_war_url
      'http://mirrors.jenkins-ci.org/war/'
    end


    def base_path
      File.join(ENV['HOME'], '.jenkins')
    end


    def war_files_cache
      File.join(base_path, 'war-files')
    end


    def war_unpacked_cache
      File.join(base_path, 'wars')
    end


    def server_path
      File.join(base_path, 'server')
    end


    def infos
      {
        jenkins_war_url: jenkins_war_url,
        base_path: base_path,
        war_files_cache: war_files_cache,
        war_unpacked_cache: war_unpacked_cache,
        server_path: server_path
      }
    end


    def latest_war_file
      return nil if all_war_files_as_object.empty?
      all_war_files_as_object.select { |f| f.installed? }.first
    end


    def latest_version
      latest_war_file ? latest_war_file.classpath : nil
    end


    def list
      all_war_files_as_object
    end


    def download(version)
      war_file = build_war_file(version)
      war_file.download!
      war_file
    end


    def remove(version)
      war_file = build_war_file(version)
      war_file.remove! if war_file.exists?
      war_file
    end


    def install(version)
      war_file = build_war_file(version)
      war_file.install!
      war_file
    end


    def unpack(version)
      war_file = build_war_file(version)
      war_file.unpack!
      war_file
    end


    def clean!
      all_war_files_as_object.map(&:remove!)
    end


    def build_war_file(version)
      WarFile.new(version, build_war_file_options)
    end


    def all_war_files
      FileUtils.mkdir_p war_files_cache unless File.exists?(war_files_cache)
      Pathname.new(war_files_cache).children.select { |c| c.directory? }
    end


    private


      def build_war_file_options
        { base_url: jenkins_war_url, base_path: war_files_cache, lib_path: war_unpacked_cache, server_path: server_path, logger: ConsoleLogger.new }
      end


      def all_war_files_sorted
        all_war_files.sort.reverse
      end


      def all_war_files_as_object
        all_war_files_sorted.map { |f| build_war_file(File.basename(f)) }
      end

  end
end
