require 'spec_helper'

describe User do
  it "should create a user given valid attributes" do
    @attr = FactoryGirl.attributes_for(:user)

    user = User.new(@attr)
    user.skip_confirmation!
    user.save!
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
    user = FactoryGirl.create(:user)
    expect(user.role).to eq("user3")
  end

  it "shouldn't allow mass-assigment of role" do
    expect {
      @attr = FactoryGirl.attributes_for(:user)
      user = User.create!(@attr.merge(:role => :admin))
    }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  context "abilities" do
    context "Guest" do
      before(:each) do
        @ability = Ability.new(nil)
      end

      context "advertisements" do
        it "should see published advertisements" do
          ads = FactoryGirl.create(:advertisement)

          ads.send_to_approval
          ads.approve
          ads.publish
          expect(@ability).to be_able_to(:read, ads)
        end

        it "shouldn't see not published advertisements" do
          ads = FactoryGirl.create(:advertisement)

          expect(@ability).not_to be_able_to(:read, ads)
        end

        it "shouldn't be able to create/update/destory advertisements" do
          expect(@ability).not_to be_able_to(:create, Advertisement)
          expect(@ability).not_to be_able_to(:update, Advertisement)
          expect(@ability).not_to be_able_to(:destroy, Advertisement)
        end

        it "shouldn't be able to transfer states on advertisements" do
          expect(@ability).not_to be_able_to(:return_to_rough, Advertisement)
          expect(@ability).not_to be_able_to(:send_to_approval, Advertisement)
          expect(@ability).not_to be_able_to(:approve, Advertisement)
          expect(@ability).not_to be_able_to(:reject, Advertisement)
        end
      end

      context "types" do
        it "shouldn't be able to do anything with types" do
          expect(@ability).not_to be_able_to(:manage, Type)
        end
      end

      context "users" do
        it "shouldn't be able to do anything with users except show" do
          expect(@ability).to be_able_to(:show, User)
          expect(@ability).not_to be_able_to(:index, User)
          expect(@ability).not_to be_able_to(:create, User)
          expect(@ability).not_to be_able_to(:update, User)
          expect(@ability).not_to be_able_to(:destroy, User)
          expect(@ability).not_to be_able_to(:set_role, User)
        end
      end
    end

    context "User" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @ability = Ability.new @user
      end

      context "advertisements" do
        it "should see advertisements" do
          expect(@ability).to be_able_to(:read, Advertisement)
        end

        it "should be able to create/update/destory own advertisements" do
          ads = FactoryGirl.create(:advertisement, :user_id => @user.id)

          expect(@ability).to be_able_to(:create, ads)
          expect(@ability).to be_able_to(:update, ads)
          expect(@ability).to be_able_to(:destroy, ads)
        end

        it "shouldn't be able to update/destory not own advertisements" do
          ads = FactoryGirl.create(:advertisement)

          expect(@ability).not_to be_able_to(:update, ads)
          expect(@ability).not_to be_able_to(:destroy, ads)
        end

        it "shouldn't be able to update own advertisements if it's not rough" do
          ads = FactoryGirl.create(:advertisement, :user_id => @user.id)
          ads.send_to_approval

          expect(@ability).not_to be_able_to(:update, ads)
        end

        it "should be able to transfer certain states" do
          ads = FactoryGirl.create(:advertisement, :user_id => @user.id)

          expect(@ability).to be_able_to(:return_to_rough, ads)
          expect(@ability).to be_able_to(:send_to_approval, ads)
        end

        it "shouldn't be able to approve/reject advertisements" do
          ads = FactoryGirl.create(:advertisement, :user_id => @user.id)

          expect(@ability).not_to be_able_to(:approve, ads)
          expect(@ability).not_to be_able_to(:reject, ads)
        end
      end

      context "types" do
        it "shouldn't be able to do anything with types" do
          expect(@ability).not_to be_able_to(:manage, Type)
        end
      end

      context "users" do
        # here, we test for ability to manage users throug users controller
        # user always can manage himself through Devise
        it "shouldn't be able to do anything with users except show" do
          expect(@ability).to be_able_to(:show, User)
          expect(@ability).not_to be_able_to(:index, User)
          expect(@ability).not_to be_able_to(:create, User)
          expect(@ability).not_to be_able_to(:update, User)
          expect(@ability).not_to be_able_to(:destroy, User)
          expect(@ability).not_to be_able_to(:set_role, User)
        end
      end
    end

    context "Admin" do
      before(:each) do
        @user = FactoryGirl.build(:user)
        @user.role = :admin
        @user.save!
        @ability = Ability.new @user
      end

      context "advertisements" do
        it "should see and destroy any advertisements" do
          expect(@ability).to be_able_to(:read, Advertisement)
          expect(@ability).to be_able_to(:destroy, Advertisement)
        end

        it "shouldn't be able to create/update advertisements" do
          expect(@ability).not_to be_able_to(:create, Advertisement)
          expect(@ability).not_to be_able_to(:update, Advertisement)
        end

        it "should be able to transfer certain states" do
          expect(@ability).to be_able_to(:return_to_rough, Advertisement)
          expect(@ability).to be_able_to(:approve, Advertisement)
          expect(@ability).to be_able_to(:reject, Advertisement)
        end

        it "shouldn't be able to transfer certain states" do
          expect(@ability).not_to be_able_to(:send_to_approval, Advertisement)
        end
      end

      context "types" do
        it "should be able to do anything with types" do
          expect(@ability).to be_able_to(:manage, Type)
        end
      end

      context "users" do
        it "should be able to do anything with users" do
          expect(@ability).to be_able_to(:manage, User)
          expect(@ability).to be_able_to(:set_role, User)
        end

        it "shouldn't be able to destroy/update/set_role himself" do
          expect(@ability).not_to be_able_to(:update, @user)
          expect(@ability).not_to be_able_to(:destroy, @user)
          expect(@ability).not_to be_able_to(:set_role, @user)
        end
      end
    end
  end
end
