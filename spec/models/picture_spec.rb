require 'spec_helper'

describe Picture do
  before(:each) do
    @attr = {:url => "http://img5.imagebanana.com/img/w8kswt57/SMTH.jpg"}
  end

  it "should create a picture given valid attributes" do
    Picture.create!(@attr)
  end

  it { should validate_presence_of(:url) }

  it { should belong_to(:advertisement) }

  it "should require url to be url" do
    should_not allow_value("non-http:/somewrongstuff").for(:url)
    should_not allow_value("http://img5.imagebanana.com/img/w8kswt57/SMTH.non-jpg").for(:url)
  end

end
