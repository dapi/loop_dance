module LoopDance

  autoload :Task,  "loop_dance/task"
  autoload :Dancer,  "loop_dance/dancer"

  class << self
    
    def start_all( force=false )
      return puts "LoopDance: No dancers defined" if LoopDance::Dancer.subclasses.empty?
      LoopDance::Dancer.subclasses.each do |dancer|
        dancer.controller.safely_start if force || dancer.start_automatic
      end
    end

    def stop_all
      return puts "LoopDance: No dancers defined" if LoopDance::Dancer.subclasses.empty?
      LoopDance::Dancer.subclasses.each do |dancer|
        dancer.controller.safely_stop
      end
    end
    
  end
  
end

begin
  require 'loop_dance/railtie'
rescue LoadError => e
  puts "Can't load loop_dance/railtie"
end
