module LoopDance
  
  module Commands

    def self.super_attr_accessor(*syms)
      attr_writer *syms
      syms.each do |sym|
        next if sym.is_a?(Hash)
        class_eval  "def #{sym} value = (nil;flag=true); if flag; return @#{sym}; else; @#{sym} = value; end ; end"
      end
    end
      
    super_attr_accessor( :mute_log, :autostart, :trap_signals,
      :start_timeout, :stop_timeout, :log_file_activity_timeout, :tasks )

    
    attr_reader :timeout
    

    def inherited(subclass)
      subclass.trap_signals = true
    end

    def every( interval, &block )
      @tasks = [] unless @tasks
      @tasks << LoopDance::Task.new( self, interval, &block )
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
            break unless @run
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
    
    def stop_me
      @run = false
    end
    
    def pid_file
      "log/#{name.underscore}.pid"
    end
      
    def log(text, forced=false)
      puts "#{Time.now} #{self}: #{text}" if forced || !mute_log
    end

    def print_status
      puts  "#{self}: timeout: #{@timeout.inspect}, status: #{self.controller.running? ? 'running' : 'stopped'}\n"
      if tasks.empty?
        puts "  no tasks defined"
      else
        tasks.each_with_index do |task,index|
          puts "  Task ##{index} runs every #{task.interval.inspect}"
        end
      end
    end
    
    private

    attr_accessor :run

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
