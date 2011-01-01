module LoopDance

  autoload :Task,  "loop_dance/task"
  autoload :Dancer,  "loop_dance/dancer"

  def self.auto_start
    return puts "LoopDance: No dancers to start" if LoopDance::Dancer.subclasses.empty?
    LoopDance::Dancer.subclasses.each do |dancer|
      dancer.controller.auto_start if dancer.start_automatic
    end
  end
  
end

begin
  require 'loop_dance/railtie'
rescue LoadError => e
  puts "Can't load loop_dance/railtie"
end
