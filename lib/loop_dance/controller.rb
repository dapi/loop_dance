require 'daemon_controller'

module LoopDance
  class Controller < DaemonController

    cattr_accessor :dancer, :start_timeout

    self.start_timeout = 45

    class << self

      def new( dancer )
        self.dancer = dancer
        h = {
          :identifier => dancer.name,
          :daemonize_for_me => true,
          :start_command => start_command,
          :ping_command => lambda { true },
          :pid_file => dancer.pid_file,
          :log_file => log_file,
          :start_timeout => start_timeout,
          :log_file_activity_timeout => dancer.maximal_timeout + 3  # 3 seconds to stock
        }
        super h
      end
            
      def log_file
        dancer.pid_file.gsub '.pid', '.log'
      end

      def start_command
        if defined? Rails
          "rails runner -e #{Rails.env} '#{dancer}.dance' 2>&1 >>#{log_file}"
        else
          "rails runner '#{dancer}.dance' 2>&1 >>#{log_file}"
        end
        
      end
    end
    
    def safely_start
      dancer.log  "Starting.. (#{@start_command})"
      if running?
        dancer.log "Dancer is already running"
      else
        start
        dancer.log "Started"
      end
    rescue => exception # DaemonController::StartTimeout
      log_exception exception
    end

    def safely_stop
      dancer.log  "Stopping.."
      stop if running?
    rescue => exception # DaemonController::StartTimeout
      log_exception exception
    end

    #stop
    #start
    #running

    private

    def log_exception( exception )
      dancer.log "Exception #{dancer}: #{exception.inspect}"
      dancer.log  exception.backtrace if exception.inspect=~/DaemonController/ && defined?( Rails ) && !Rails.env.production? 
    end
  
  end
end
