require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LoopDance do 

  describe "setup" do
  end

  describe "finds minimal interval"

  describe "examples" do 

    before(:all) do
      class Dancer1 < LoopDance::Dancer
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
    it { Dancer1.timeout.should == 2 }
    it { LoopDance::Dancer.tasks.should be_blank }
    it { Dancer1.maximal_timeout.should == 10 }


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
      it { Dancer2.timeout.should == 1 }
      it { Dancer2.maximal_timeout.should == 11 }
      it { Dancer2.muted_log.should be_nil }
      it { Dancer1.autostart.should be_true }
      
    end

    describe "muting log and disabling autostart" do
      before(:all) do
        class Dancer1 < LoopDance::Dancer
          mute_log
          disable_autostart
        end
      end
      it { Dancer1.muted_log.should be_true }
      it { Dancer1.autostart.should be_false }
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
      it { Dancer3.maximal_timeout.should == 9 }
      
    end

    describe "method stop stops the loop" do
      
      before(:all) do
        class Dancer < LoopDance::Dancer
          every 2.seconds do
            stop
          end
        end
      end

      it { Dancer.dance }
      it { Dancer.maximal_timeout.should == 2 }
      
    end


    
  end
  
end
