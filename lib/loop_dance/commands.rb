module LoopDance
  
  module Commands

    attr_accessor :tasks, :timeout, :maximal_timeout
    
    def every( interval, &block )
      @tasks = [] unless @tasks
      @tasks << LoopDance::Task.new( interval, &block )
      find_minimal_timeout interval
      @maximal_timeout = interval if !@maximal_timeout || @maximal_timeout < interval
    end

    def dance
      loop_init
      if @tasks.empty?
        log "No tasks defined."
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
      log "shutting down"
    end
    
    def stop
      @run = false
    end
    
    def pid_file
      "log/#{name.underscore}.pid"
    end
      
    def log(text)
      puts "#{Time.now} #{self}: #{text}"
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
      
      def trap_signals
        sigtrap = proc { 
          log "caught trapped signal, shutting down"
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
        trap_signals
        @run = true
        log "Process started and sleep for #{timeout.inspect}. kill #{Process.pid} to stop"
      end

      def write_pid
        file = File.new( pid_file, "w" )
        file.print Process.pid.to_s
        file.close
      end

  end
end
