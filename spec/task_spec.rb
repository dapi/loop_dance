require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LoopDance::Task do 

  describe "setup" do
    
    before {
      @result = 0
      @task = LoopDance::Task.new 60.seconds do
        @result+=1
      end
    }
    
    subject { @task }
    
    it "should setup instance variables" do
      subject.interval.to_i.should be 60
      subject.block.should be_a Proc
    end

    it "should run block" do
      @result.should == 0
      subject.run
      @result.should == 1
    end
    
  end
  
end
