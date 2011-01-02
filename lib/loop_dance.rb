module LoopDance

  autoload :Task,  "loop_dance/task"
  autoload :Dancer,  "loop_dance/dancer"

  class << self
    
    def start_all( force=false )
      return puts "LoopDance: No dancers defined" if LoopDance::Dancer.subclasses.empty?
      LoopDance::Dancer.subclasses.each do |dancer|
        dancer.controller.safely_start if force || dancer.autostart
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

require 'loop_dance/railtie' if defined? Rails
