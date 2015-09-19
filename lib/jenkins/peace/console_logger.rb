module Jenkins
  module Peace
    class ConsoleLogger

      RED    = "\e[31m"
      GREEN  = "\e[32m"
      YELLOW = "\e[33m"
      CLEAR  = "\e[0m"

      attr_reader :logger


      def initialize(logger = $stdout)
        @logger = logger
      end


      def info(message)
        logger << "#{GREEN}#{message}#{CLEAR}\n"
      end


      def warn(message)
        logger << "#{YELLOW}#{message}#{CLEAR}\n"
      end


      def error(message)
        logger << "#{RED}#{message}#{CLEAR}\n"
      end

    end
  end
end
