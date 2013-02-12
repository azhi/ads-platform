require 'spec_helper'

describe Advertisement do
  before(:each) do
    @attr = {:content => "Some content"}
  end

  it "should create an advertisement given valid attributes" do
    Advertisement.create!(@attr)
  end

  it "should require non-empty content" do
    ads = Advertisement.new(@attr.merge(:content => ""))
    ads.should_not be_valid
  end

  it "should reject too long content" do
    ads = Advertisement.new(@attr.merge(:content => "a" * 2001))
    ads.should_not be_valid
  end

  describe "association testing" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
      @ads = @type.advertisements.create!(@attr)
    end

    it "should have a type attribute" do
      @ads.should respond_to(:type)
    end

    it "should have a right type attribute" do
      @ads.type.should == @type
    end

    it "should have a pictures attribute" do
      @ads.should respond_to(:pictures)
    end
  end

  describe "states testing" do
    before(:each) do
      @ads = Advertisement.create!(@attr)
    end

    it "should have state attribute" do
      @ads.should respond_to(:state)
    end

    it "should have initial :rough state" do
      @ads.state?(:rough).should be_true
    end

    it "should go through successfull cycle with correct states" do
      @ads.send_to_approval
      @ads.state?(:new).should be_true
      @ads.approve
      @ads.state?(:approved).should be_true
      @ads.publish
      @ads.state?(:published).should be_true
      @ads.transfer_to_archive
      @ads.state?(:archived).should be_true
      @ads.return_to_rough
      @ads.state?(:rough).should be_true
    end

    it "should go through failed cycle with correct states" do
      @ads.send_to_approval
      @ads.state?(:new).should be_true
      @ads.reject
      @ads.state?(:rejected).should be_true
      @ads.return_to_rough
      @ads.state?(:rough).should be_true
    end

    it "should save the date of publishing in database" do
      @ads.send_to_approval
      @ads.approve
      @ads.publish
      @ads.reload
      @ads.published_at.should == Date.current
    end

    it "shouldn't allow to publish rejected ads" do
      @ads.send_to_approval
      @ads.reject
      @ads.publish
      @ads.state?(:published).should_not be_true
    end
  end
end
