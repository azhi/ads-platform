require 'spec_helper'

describe AdvertisementsController do
  render_views

  describe "get :show" do
    before(:each) do
      @ads = FactoryGirl.create(:advertisement)
      @pic = FactoryGirl.create(:picture, :advertisement_id => @ads.id)
    end

    it "should be succesfull" do
      get :show, :id => @ads
      expect(response).to be_success
    end

    it "should find the right ads" do
      get :show, :id => @ads
      expect(assigns(:ads)).to eq(@ads)
    end

    it "should display content of the ads" do
      get :show, :id => @ads
      expect(response).to have_selector("p", :content => @ads.content)
    end

    it "should display ads picture" do
      get :show, :id => @ads
      expect(response).to have_selector("img", :src => @ads.pictures.first.url)
    end
  end

  describe "get :index" do
    before(:each) do
      @all_ads = []
      5.times do
        @all_ads << FactoryGirl.create(:advertisement)
      end
    end

    it "should be successfull" do
      get :index
      expect(response).to be_success
    end

    it "should have an element for each ads" do
      get :index
      @all_ads.each do |ads|
        expect(response).to have_selector("li", :content => ads.content.first(6))
      end
    end
  end

  describe "get :edit" do
    before(:each) do
      @ads = FactoryGirl.create(:advertisement)
    end

    it "should be successfull" do
      get :edit, :id => @ads
      expect(response).to be_success
    end
  end

  describe "put :update" do
    before(:each) do
      @ads = FactoryGirl.create(:advertisement)
    end

    describe "failures: " do
      before(:each) do
        @attr = { :content => "" }
      end

      it "should re-render edit page" do
        put :update, :id => @ads, :advertisement => @attr
        expect(response).to render_template(:edit)
      end
    end

    describe "success: " do
      before(:each) do
        @attr = FactoryGirl.attributes_for(:advertisement)
      end

      it "should change ads attributes" do
        put :update, :id => @ads, :advertisement => @attr
        @ads.reload
        expect(@ads.content).to eq(@attr[:content])
      end

      it "should redirect to ads show page" do
        put :update, :id => @ads, :advertisement => @attr
        expect(response).to redirect_to(advertisement_path(@ads))
      end
    end
  end

  describe "get :new" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should be succesfull" do
      get :new, :user_id => @user.id
      expect(response).to be_success
    end
  end

  describe "post :create" do
    describe "failures: " do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @type = FactoryGirl.create(:type)
        @attr = { :content => "", :user_id => @user.id, :type_id => @type.id }
      end

      it "shouldn't create an ads" do
        expect {
          post :create, :advertisement => @attr
        }.not_to change(Advertisement, :count)
      end

      it "should re-render new page" do
        post :create, :advertisement => @attr
        expect(response).to render_template(:new)
      end
    end

    describe "success: " do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @type = FactoryGirl.create(:type)
        @attr = FactoryGirl.attributes_for(:advertisement, :user_id => @user.id, :type_id => @type.id)
      end

      it "should create an ads" do
        expect {
          post :create, :advertisement => @attr
        }.to change(Advertisement, :count).by(1)
      end

      it "should redirect to ads show page" do
        post :create, :advertisement => @attr
        expect(response).to redirect_to(advertisement_path(assigns(:ads)))
      end
    end
  end

  describe "delete :destroy" do
    before(:each) do
      @ads = FactoryGirl.create(:advertisement)
    end

    it "should delete user" do
      expect {
        delete :destroy, :id => @ads
      }.to change(Advertisement, :count).by(-1)
    end

    it "should redirect to index page" do
      delete :destroy, :id => @ads
      expect(response).to redirect_to(advertisements_path)
    end
  end
end
