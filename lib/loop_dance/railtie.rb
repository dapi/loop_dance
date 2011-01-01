require 'rails'
module LoopDance

  class Railtie < Rails::Railtie
    
    initializer 'loop_dance.initialize', :after => :after_initialize do

      load_dancers
      # Do not start dancers if rake or other tasks
      LoopDance.auto_start if server_startup?
    end

    def load_dancers
      require 'dancers'
    end

    # FIX: Is there more cute solution?
    def server_startup?
      caller.to_s=~/config\.ru/
    end

    rake_tasks do
      #load "path/to/my_railtie.tasks"
    end
    
  end
end
