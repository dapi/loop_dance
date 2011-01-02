require 'rails'
module LoopDance

  class Railtie < Rails::Railtie

    def self.load_dancers
      require 'dancers'
    rescue LoadError => err
      puts "LoopDance: file 'lib/dancers.rb' doesn't exist."
    end

    initializer 'loop_dance.initialize' do
      self.class.load_dancers
      # Do not start dancers if rake or other tasks
      LoopDance.start_all if server_startup?
    end


    # FIX: Is there more cute solution?
    def server_startup?
      caller.to_s=~/config\.ru/
    end

    rake_tasks do
      load_dancers
      load File.expand_path('../../../tasks/loop_dance.rake', __FILE__)
    end
    
  end
end
