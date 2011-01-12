require 'active_support/core_ext'

module LoopDance
  
  autoload :Commands, 'loop_dance/commands'
  autoload :Controller, 'loop_dance/controller'

  class Dancer
    
    extend LoopDance::Commands
    
    class << self
      
      def inherited(subclass)
        subclass.autostart = true
      end
      # Can start daemon automatically at rails server startup? true by default
      
      def controller
        @controller ||= LoopDance::Controller.new self
      end

      def stop
        controller.stop
      end
      
      def start
        controller.start
      end

      def running?
        controller.running?
      end

    end
    
  end
end
