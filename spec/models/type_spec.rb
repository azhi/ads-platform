require 'spec_helper'

describe Type do
  before(:each) do
    @attr = FactoryGirl.attributes_for(:type)
  end

  it "should create a type given valid attributes" do
    Type.create!(@attr)
  end

  it { should validate_presence_of(:name) }

  it { should ensure_length_of(:name).
       is_at_least(2).
       is_at_most(20) }

  it { should have_many(:advertisements) }
end
