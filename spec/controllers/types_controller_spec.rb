require 'spec_helper'

describe TypesController do
  render_views

  describe "get :index" do
    before(:each) do
      @types = []
      5.times do
        @types << FactoryGirl.create(:type)
      end
    end

    it "should be successfull" do
      get :index
      expect(response).to be_success
    end

    it "should have an element for each ads" do
      get :index
      @types.each do |type|
        expect(response).to have_selector("li", :content => type.name)
      end
    end
  end

  describe "get :edit" do
    before(:each) do
      @type = FactoryGirl.create(:type)
    end

    it "should be successfull" do
      get :edit, :id => @type
      expect(response).to be_success
    end
  end

  describe "put :update" do
    before(:each) do
      @type = FactoryGirl.create(:type)
    end

    describe "failures: " do
      before(:each) do
        @attr = { :name => "" }
      end

      it "should re-render edit page" do
        put :update, :id => @type, :type => @attr
        expect(response).to render_template(:edit)
      end
    end

    describe "success: " do
      before(:each) do
        @attr = FactoryGirl.attributes_for(:type)
      end

      it "should change type attributes" do
        put :update, :id => @type, :type => @attr
        @type.reload
        expect(@type.name).to eq(@attr[:name])
      end

      it "should redirect to index page" do
        put :update, :id => @type, :type => @attr
        expect(response).to redirect_to(types_path)
      end
    end
  end

  describe "get :new" do
    it "should be succesfull" do
      get :new
      expect(response).to be_success
    end
  end

  describe "post :create" do
    describe "failures: " do
      before(:each) do
        @attr = { :name => "" }
      end

      it "shouldn't create a type" do
        expect {
          post :create, :type => @attr
        }.not_to change(Type, :count)
      end

      it "should re-render new page" do
        post :create, :type => @attr
        expect(response).to render_template(:new)
      end
    end

    describe "success: " do
      before(:each) do
        @attr = FactoryGirl.attributes_for(:type)
      end

      it "should create a type" do
        expect {
          post :create, :type => @attr
        }.to change(Type, :count).by(1)
      end

      it "should redirect to index page" do
        post :create, :type => @attr
        expect(response).to redirect_to(types_path)
      end
    end
  end

  describe "delete :destroy" do
    before(:each) do
      @type = FactoryGirl.create(:type)
    end

    it "should delete type" do
      expect {
        delete :destroy, :id => @type
      }.to change(Type, :count).by(-1)
    end

    it "should redirect to index page" do
      delete :destroy, :id => @type
      expect(response).to redirect_to(types_path)
    end
  end
end
