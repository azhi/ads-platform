require 'spec_helper'

describe Type do
  before(:each) do
    @attr = {:name => "Some type"}
  end

  it "should create a type given valid attributes" do
    Type.create!(@attr)
  end

  it "should require non-empty name" do
    type = Type.new(@attr.merge(:name => ""))
    type.should_not be_valid
  end

  it "should reject too short and too long names" do
    type = Type.new(@attr.merge(:name => "a"))
    type.should_not be_valid
    type = Type.new(@attr.merge(:name => "a" * 21))
    type.should_not be_valid
  end

  describe "association testing" do
    before(:each) do
      @type = Type.create!(@attr)
    end

    it "should have an advertisements attribute" do
      @type.should respond_to(:advertisements)
    end
  end
end
