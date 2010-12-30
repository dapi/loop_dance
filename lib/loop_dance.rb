require 'active_support/core_ext'


class LoopDance

  require 'loop_dance/task'
  
  cattr_accessor :tasks, :timeout, :run
  self.tasks = []
  
  class << self
    
    def every( interval, &block )
      self.tasks << LoopDance::Task.new( interval, &block )
      self.timeout = interval if self.timeout.blank? || interval < self.timeout
    end
    
    def loopme
      loop_init
      if tasks.empty?
          puts "No tasks defined."
        else
          while (@run) do
            tasks.each do |task|
              task.run if task.time_to_run?
            end
            sleep timeout.to_i
          end
        end
        puts "#{Time.now} shutting down"
      end
      
      private
      
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

  
