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
    
    def auto_start
      dancer.log  "Starting.. (#{@start_command})"
      start unless running?
    rescue => exception # DaemonController::StartTimeout
      dancer.log "Exception until starting #{dancer}: #{exception.inspect}"
      dancer.log  exception.backtrace if defined?( Rails ) && !Rails.env.production?
    end
    
    
    #stop
    #start
    #running
  
  end
end
