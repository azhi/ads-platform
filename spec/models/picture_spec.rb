require 'spec_helper'

describe Picture do
  before(:each) do
    @attr = {:url => "http://img5.imagebanana.com/img/w8kswt57/SMTH.jpg"}
  end

  it "should create a picture given valid attributes" do
    Picture.create!(@attr)
  end

  it "should require non-empty url" do
    pic = Picture.new(@attr.merge(:url => ""))
    pic.should_not be_valid
  end

  it "should require url to be url" do
    pic = Picture.new(@attr.merge(:url => "non-http:/somewrongstuff"))
    pic.should_not be_valid
  end

  it "should require url end with picture extention" do
    pic = Picture.new(@attr.merge(:url => "http://img5.imagebanana.com/img/w8kswt57/SMTH.non-jpg"))
    pic.should_not be_valid
  end

  describe "association testing" do
    before(:each) do
      @pic = Picture.create!(@attr)
    end

    it "should have a advertisements attribute" do
      @pic.should respond_to(:advertisements)
    end
  end
end
