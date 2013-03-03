require 'spec_helper'

describe Advertisement do
  it "should create an advertisement given valid attributes" do
    @type = FactoryGirl.create(:type)
    @user = FactoryGirl.create(:user)
    @attr = FactoryGirl.attributes_for(:advertisement, :type_id => @type.id)

    @ads = Advertisement.new(@attr)
    @ads.user = @user
    @ads.save!
  end

  it { should validate_presence_of(:content) }

  it { should ensure_length_of(:content).is_at_most(2000) }

  it { should belong_to(:type) }

  it { should belong_to(:user) }

  it { should have_many(:pictures) }

  context "publishing/archiving" do
    before(:each) do
      @ads = []

      @ads1 = FactoryGirl.build(:advertisement)
      @ads1.state = :approved
      @ads1.save!
      @ads << @ads1

      @ads2 = FactoryGirl.build(:advertisement)
      @ads2.state = :waiting_for_approval
      @ads2.save!
      @ads << @ads2

      @ads3 = FactoryGirl.build(:advertisement)
      @ads3.state = :published
      @ads3.published_at = Date.current - 3.days
      @ads3.save!
      @ads << @ads3

      @ads4 = FactoryGirl.build(:advertisement)
      @ads4.state = :published
      @ads4.save!
      @ads << @ads4
    end

    it "should publish all approved ads" do
      Advertisement.publish_approved
      @ads.each{ |ad| ad.reload }
      expect(@ads1).to be_published
      expect(@ads2).to be_waiting_for_approval
      expect(@ads3).to be_published
      expect(@ads4).to be_published
    end

    it "should archive 3 days old published ads" do
      Advertisement.archive_published
      @ads.each{ |ad| ad.reload }
      expect(@ads1).to be_approved
      expect(@ads2).to be_waiting_for_approval
      expect(@ads3).to be_archived
      expect(@ads4).to be_published
    end
  end

  context "states testing" do
    before(:each) do
      @ads = FactoryGirl.create(:advertisement)
    end

    it "should have state attribute" do
      expect(@ads).to respond_to(:state)
    end

    it "should have initial :rough state" do
      expect(@ads.state?(:rough)).to be_true
    end

    it "should go through successfull cycle with correct states" do
      @ads.send_to_approval
      expect(@ads.state?(:waiting_for_approval)).to be_true
      @ads.approve
      expect(@ads.state?(:approved)).to be_true
      @ads.publish
      expect(@ads.state?(:published)).to be_true
      @ads.archive
      expect(@ads.state?(:archived)).to be_true
      @ads.return_to_rough
      expect(@ads.state?(:rough)).to be_true
    end

    it "should go through failed cycle with correct states" do
      @ads.send_to_approval
      expect(@ads.state?(:waiting_for_approval)).to be_true
      @ads.reject
      expect(@ads.state?(:rejected)).to be_true
      @ads.return_to_rough
      expect(@ads.state?(:rough)).to be_true
    end

    it "should save the date of publishing in database" do
      @ads.send_to_approval
      @ads.approve
      @ads.publish
      @ads.reload
      expect(@ads.published_at).to eq(Date.current)
    end

    it "shouldn't allow to publish rejected ads" do
      @ads.send_to_approval
      @ads.reject
      @ads.publish
      expect(@ads.state?(:published)).to be_false
    end
  end
end
