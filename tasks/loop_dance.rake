# encoding: utf-8

#require 'watchdog'
 
namespace :loop_dance do

  task :loop_dance => :environment do
  end

  desc "Start (or restart) all dancers"
  task :start_all => :loop_dance do 
    LoopDance.start_all
  end

  desc "Start restart all dancers"
  task :restart_all => :loop_dance do 
    LoopDance.restart_all
  end

  desc "Stop all dancers"
  task :stop_all => :loop_dance do
    LoopDance.stop_all
  end

  desc "Status of all dancers"
  task :status => :loop_dance do
    return puts "LoopDance: No dancers defined" if LoopDance::Dancer.subclasses.empty?
    LoopDance::Dancer.subclasses.each do |dancer|
      dancer.print_status
    end
  end

  LoopDance::Dancer.subclasses.each do |dancer|
    
    namespace dancer.name.underscore.to_sym do
      
      desc "Start (or restart) all #{dancer}"
      task :start => :loop_dance do
        dancer.controller.safely_start
      end
      
      desc "Stop #{dancer}"
      task :stop => :loop_dance do
        dancer.controller.safely_stop
      end
      
      desc "Status of #{dancer}"
      task :status => :loop_dance do
        dancer.print_status
      end
      
    end
    
  end
end


