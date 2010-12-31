require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LoopDance do 

  describe "setup" do
  end

  describe "finds minimal interval"

  describe "examples" do 

    before(:all) do
      class Dancer1 < LoopDance
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
    it { LoopDance.tasks.should be_blank }

    describe "another dancer not change first dancer's tasks" do
      
      before(:all) do
        class Dancer2 < LoopDance
          every 6.seconds do
          end
          every 11.seconds do
          end
        end
      end

      it { Dancer2.tasks.count.should == 2 }
      it { Dancer2.timeout.should == 1 }
      
    end

    describe "find right minimal timeout" do
      
      before(:all) do
        class Dancer3 < LoopDance
          every 6.seconds do
          end
          every 9.seconds do
          end
        end
      end

      it { Dancer3.tasks.count.should == 2 }
      it { Dancer3.timeout.should == 3 }
      
    end

    describe "method stop stops the loop" do
      
      before(:all) do
        class Dancer < LoopDance
          every 2.seconds do
            stop
          end
        end
      end

      it { Dancer.loopme }
      
    end


    
  end
  
end
