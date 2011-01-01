require 'active_support/core_ext'

module LoopDance
  
  autoload :Commands, 'loop_dance/commands'
  autoload :Controller, 'loop_dance/controller'

  class Dancer
    
    extend LoopDance::Commands

    class << self

      # Can start daemon automatically at rails server startup? true by default
      cattr_accessor :start_automatic
      self.start_automatic = true
      
      def controller
        @controller ||= LoopDance::Controller.new self
      end

    end
    
  end
end
