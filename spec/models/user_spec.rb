require 'spec_helper'

describe User do
  before(:each) do
    @attr = FactoryGirl.attributes_for(:user)
  end

  it "should create a user given valid attributes" do
    User.create!(@attr)
  end

  it { should validate_presence_of(:nickname) }

  it { should ensure_length_of(:nickname).
       is_at_least(4).
       is_at_most(25) }

  it { should validate_presence_of(:email) }

  it "should require email to be email" do
    should_not allow_value("somemail@com").for(:email)
    should_not allow_value("@example.com").for(:email)
    should_not allow_value("as@ex@ex2.com").for(:email)
  end

  it { should have_many(:advertisements) }

  it "should create a user with default role :user" do
    user = User.create(@attr)
    expect(user.role).to eq("user")
  end

  it "shouldn't allow mass-assigment of role" do
    expect {
      user = User.create(@attr.merge(:role => :admin))
    }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
end
