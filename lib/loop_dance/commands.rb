module LoopDance
  
  module Commands
    
    # # options
    attr_accessor :muted_log, :autostart, :trap_signals,
    :start_timeout, :stop_timeout, :log_file_activity_timeout

    def inherited(subclass)
      subclass.trap_signals = true
    end

    def enable_autostart
      @autostart = true
    end

    def mute_log
      @muted_log = true
    end

    def every( interval, &block )
      @tasks = [] unless @tasks
      @tasks << LoopDance::Task.new( interval, &block )
      find_minimal_timeout interval
      @maximal_timeout = interval if !@maximal_timeout || @maximal_timeout < interval
    end

    def dance
      loop_init
      if @tasks.empty?
        log "No tasks defined.", true
      else
        while (@run) do
          @tasks.each_with_index do |task, index|
            if task.time_to_run?
              log "Run task ##{index} for every #{task.interval.inspect}"
              task.run 
            end
            break unless @run
          end
            log "Sleep for #{@timeout.inspect}"
            sleep @timeout.to_i if @run
          end
        end
      log "shutting down", true
    end
    
    def stop
      @run = false
    end
    
    def pid_file
      "log/#{name.underscore}.pid"
    end
      
    def log(text, forced=false)
      puts "#{Time.now} #{self}: #{text}" if forced || !muted_log
    end

    def print_status
      puts  "#{self}: timeout: #{self.timeout.inspect}, status: #{self.controller.running? ? 'running' : 'stopped'}\n"
      if tasks.empty?
        puts "  no tasks defined"
      else
        tasks.each_with_index do |task,index|
          puts "  Task ##{index} runs every #{task.interval.inspect}"
        end
      end
    end
    
    private

    def find_minimal_timeout( interval )
      return @timeout = interval if @timeout.blank?
      minimal = interval < @timeout ? interval : @timeout
      while not timeout_devides? minimal
        minimal-=1
      end
        @timeout = minimal
      end

      def timeout_devides?( timeout )
        @tasks.each { |task|
          m = (task.interval / timeout).to_i
          return false unless m * timeout == task.interval
        }
        return true
      end
      
      def do_trap_signals
        log "Trap signals"
        sigtrap = proc { 
          log "caught trapped signal, shutting down", true
          @run = false 
        }
        ["SIGTERM", "SIGINT", "SIGHUP"].each do |signal|
          trap signal, sigtrap
        end
      end
      
      def loop_init
        # we don't want to delay output to sdtout until the program stops, we want feedback!
        $stdout.sync=true
        write_pid
        do_trap_signals if trap_signals
        @run = true
        log "Process started and sleep for #{@timeout.inspect}. kill #{Process.pid} to stop", true
      end

      def write_pid
        file = File.new( pid_file, "w" )
        file.print Process.pid.to_s
        file.close
      end

  end
end
