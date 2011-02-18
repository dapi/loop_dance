require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LoopDance::Task do 

  describe "setup" do

    let(:interval) { 60 }
    let(:dancer) { LoopDance::Dancer }
    
    before {
      @result = 0
      @task = LoopDance::Task.new dancer, interval do
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
      subject.last_run_at.should < Time.now
    end

    it "should  run straight away" do
      should be_time_to_run
    end

    it "should run if it's time" do
      t = Time.now()
      Time.stub(:now).and_return(t + interval)
      should be_time_to_run
    end
    
  end
  
end
