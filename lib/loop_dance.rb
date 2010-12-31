require 'active_support/core_ext'


class LoopDance
  
  require 'loop_dance/task'

  #class << self; attr_accessor :tasks end
  #cattr_accessor :tasks, :timeout
  #self.tasks = []
  
  class << self

    attr_accessor :tasks, :timeout
    
    def every( interval, &block )
      @tasks = [] unless @tasks
      @tasks << LoopDance::Task.new( interval, &block )
      find_minimal_timeout interval
    end
    
    def loopme
      loop_init
      if @tasks.empty?
        puts "No tasks defined."
      else
        while (@run) do
          @tasks.each do |task|
            task.run if task.time_to_run?
            break unless @run
          end
          sleep @timeout.to_i if @run
        end
      end
      puts "#{Time.now} shutting down"
    end

    
    def stop
      @run = false
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
        puts "caught trapped signal, shutting down"
        @run = false 
      }
      ["SIGTERM", "SIGINT", "SIGHUP"].each do |signal|
        trap signal, sigtrap
      end
    end
    
    def loop_init
      # we don't want to delay output to sdtout until the program stops, we want feedback!
      $stdout.sync=true
      # write_pid
      trap_signals
      @run = true
      puts "#{Time.now} process started and sleep for #{timeout} seconds. kill #{Process.pid} to stop"
    end
    
    
    def write_pid(filename, pid=Process.pid)
      file = File.new(filename, "w")
      file.print pid.to_s
      file.close
    end
    
  end
  
end


