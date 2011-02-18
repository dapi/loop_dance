require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LoopDance do 

  # describe "finds minimal interval"
  
  describe "examples" do 
    
    before(:all) do
      class Dancer1 < LoopDance::Dancer
        start_timeout 60
        every 2.seconds do
        end
        every 4.seconds do
        end
        every 6.seconds do
        end
        every 10.seconds do
        end
      end
    end


    it { Dancer1.tasks.count.should == 4 }
    it { Dancer1.start_timeout.should == 60 }
    it { Dancer1.stop_timeout.should be_nil }
    it { Dancer1.autostart.should be_false }
    
    it { LoopDance::Dancer.tasks.should be_blank }


     describe "another dancer not change first dancer's tasks" do
      
      before(:all) do
        class Dancer2 < LoopDance::Dancer
          every 6.seconds do
          end
          every 11.seconds do
          end
        end
      end

      it { Dancer2.tasks.count.should == 2 }
      it { Dancer2.mute_log.should be_nil }
      it { Dancer2.autostart.should be_false }
      
    end

    describe "muting log and enabling autostart" do
      before(:all) do
        class Dancer1 < LoopDance::Dancer
          mute_log true
          autostart true
        end
      end
      it { Dancer1.mute_log.should be_true }
      it { Dancer1.autostart.should be_true }
    end

    describe "find right minimal timeout" do
      
      before(:all) do
        class Dancer3 < LoopDance::Dancer
          every 6.seconds do
          end
          every 9.seconds do
          end
        end
      end

      it { Dancer3.tasks.count.should == 2 }
      it { Dancer3.timeout.should == 3 }
      
    end

    describe "calculate minimal interval" do
      
      before(:all) do
        class Dancer < LoopDance::Dancer
          mute_log true
          every 2.seconds do
            stop_me
          end
        end
      end

      it { Dancer.dance }
      it { Dancer.send(:run).should be_false }
      it { Dancer.timeout.should == 2 }
      
    end

    
  end
  
end
