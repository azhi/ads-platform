require 'spec_helper'

describe AdvertisementsController do
  render_views

  describe "get :show" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
      @ads = @type.advertisements.create!(:content => "Bla bla")
      @ads.pictures.create(:url => "http://someurl.com/somepicture.jpg")
    end

    it "should be succesfull" do
      get :show, :id => @ads
      response.should be_success
    end

    it "should find the right ads" do
      get :show, :id => @ads
      assigns(:ads).should == @ads
    end

    it "should display content of the ads" do
      get :show, :id => @ads
      response.should have_selector("p", :content => @ads.content)
    end

    it "should display ads picture" do
      get :show, :id => @ads
      response.should have_selector("img", :src => @ads.pictures.first.url)
    end
  end

  describe "get :index" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
      @all_ads = []
      @all_ads << @type.advertisements.create!(:content => "Bla bla")
      @all_ads << @type.advertisements.create!(:content => "Other bla bla")
      @all_ads << @type.advertisements.create!(:content => "Nice bla bla")
    end

    it "should be successfull" do
      get :index
      response.should be_success
    end

    it "should have an element for each ads" do
      get :index
      @all_ads.each do |ads|
        response.should have_selector("li", :content => ads.content.first(6))
      end
    end
  end

  describe "get :edit" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
      @ads = @type.advertisements.create!(:content => "Bla bla")
    end

    it "should be successfull" do
      get :edit, :id => @ads
      response.should be_success
    end
  end

  describe "put :update" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
      @ads = @type.advertisements.create!(:content => "Bla bla")
    end

    describe "failures: " do
      before(:each) do
        @attr = { :content => "" }
      end

      it "should re-render edit page" do
        put :update, :id => @ads, :advertisement => @attr
        response.should render_template(:edit)
      end
    end

    describe "success: " do
      before(:each) do
        @attr = { :content => "Other bla-bla" }
      end

      it "should change ads attributes" do
        put :update, :id => @ads, :advertisement => @attr
        @ads.reload
        @ads.content.should == @attr[:content]
      end

      it "should redirect to ads show page" do
        put :update, :id => @ads, :advertisement => @attr
        response.should redirect_to(advertisement_path(@ads))
      end
    end
  end

  describe "get :new" do
    it "should be succesfull" do
      get :new
      response.should be_success
    end
  end

  describe "post :create" do
    describe "failures: " do
      before(:each) do
        @attr = { :content => "" }
      end

      it "shouldn't create an ads" do
        lambda do
          post :create, :advertisement => @attr
        end.should_not change(Advertisement, :count)
      end

      it "should re-render new page" do
        post :create, :advertisement => @attr
        response.should render_template(:new)
      end
    end

    describe "success: " do
      before(:each) do
        @attr = { :content => "Bla bla" }
      end

      it "should create an ads" do
        lambda do
          post :create, :advertisement => @attr
        end.should change(Advertisement, :count).by(1)
      end

      it "should redirect to ads show page" do
        post :create, :advertisement => @attr
        response.should redirect_to(advertisement_path(assigns(:ads)))
      end
    end
  end

  describe "delete :destroy" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
      @ads = @type.advertisements.create!(:content => "Bla bla")
    end

    it "should delete user" do
      lambda do
        delete :destroy, :id => @ads
      end.should change(Advertisement, :count).by(-1)
    end

    it "should redirect to index page" do
      delete :destroy, :id => @ads
      response.should redirect_to(advertisements_path)
    end
  end
end
