require 'ruby-progressbar'
require 'net/http'
require 'uri'

module Jenkins
  module Peace
    class ContentDownloader

      attr_reader :target_file
      attr_reader :logger


      def initialize(target_file, logger)
        @target_file = target_file
        @logger      = logger
      end


      def download(url, limit = 10)
        raise ArgumentError, 'too many HTTP redirects' if limit == 0

        start_http_session(url) do |http, uri|
          response = http.request_head(uri.path)
          case response
          when Net::HTTPSuccess
            download_content(url)
          when Net::HTTPRedirection
            redirect = response['location']
            logger.info "Redirected to : '#{redirect}'"
            download(redirect, limit - 1)
          else
            logger.error response.value
          end
        end
      rescue => e
        logger.error "Error while downloading '#{url}' : #{e.message}"
      end


      def download_content(url)
        logger.info "Downloading   : '#{url}'"
        start_http_session(url) do |http, uri|
          response = http.request_head(uri.path)
          progressbar = build_progress_bar(response['content-length'].to_i)
          File.open(target_file, 'wb') do |file|
            http.get(uri.path) do |chunk|
              file.write chunk
              progressbar.progress += chunk.length
            end
          end
        end
      rescue => e
        logger.error "Error while downloading '#{url}' : #{e.message}"
      end


      def build_progress_bar(total)
        ProgressBar.create(title: 'Downloading', starting_at: 0, total: total, format: '%a |%b>%i| %p%% %t')
      end


      def start_http_session(url)
        uri = URI(url)
        Net::HTTP.start(uri.host, uri.port) do |http|
          yield http, uri
        end
      end

    end
  end
end
