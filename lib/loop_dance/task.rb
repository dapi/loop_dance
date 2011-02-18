class LoopDance::Task
  attr_accessor :last_run_at, :dancer, :block, :interval
  
  def initialize( dancer, interval, &block )
    run_count=0
    self.dancer = dancer
    self.interval = interval
    self.block = block
    
    # Run tasks when start dancer
    # self.last_run_at = Time.now
  end
  
  def time_to_run?
    !last_run_at || last_run_at + interval <= Time.now
  end
  
  def run
    block.call
  rescue Exception => e
    puts "Uncaught exception bubbled up: \n#{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")} "
    dancer.send(:stop_dancer)
  ensure
    self.last_run_at = Time.now
  end
  
end
