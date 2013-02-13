require 'spec_helper'

describe TypesController do
  render_views

  describe "get :index" do
    before(:each) do
      @types = []
      @types << Type.create!(:name => "Some type")
      @types << Type.create!(:name => "Some other type")
      @types << Type.create!(:name => "Some nice type")
    end

    it "should be successfull" do
      get :index
      response.should be_success
    end

    it "should have an element for each ads" do
      get :index
      @types.each do |type|
        response.should have_selector("li", :content => type.name)
      end
    end
  end

  describe "get :edit" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
    end

    it "should be successfull" do
      get :edit, :id => @type
      response.should be_success
    end
  end

  describe "put :update" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
    end

    describe "failures: " do
      before(:each) do
        @attr = { :name => "" }
      end

      it "should re-render edit page" do
        put :update, :id => @type, :type => @attr
        response.should render_template(:edit)
      end
    end

    describe "success: " do
      before(:each) do
        @attr = { :name => "Other type" }
      end

      it "should change type attributes" do
        put :update, :id => @type, :type => @attr
        @type.reload
        @type.name.should == @attr[:name]
      end

      it "should redirect to index page" do
        put :update, :id => @type, :type => @attr
        response.should redirect_to(types_path)
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
        @attr = { :name => "" }
      end

      it "shouldn't create a type" do
        lambda do
          post :create, :type => @attr
        end.should_not change(Type, :count)
      end

      it "should re-render new page" do
        post :create, :type => @attr
        response.should render_template(:new)
      end
    end

    describe "success: " do
      before(:each) do
        @attr = { :name => "Some type" }
      end

      it "should create a type" do
        lambda do
          post :create, :type => @attr
        end.should change(Type, :count).by(1)
      end

      it "should redirect to index page" do
        post :create, :type => @attr
        response.should redirect_to(types_path)
      end
    end
  end

  describe "delete :destroy" do
    before(:each) do
      @type = Type.create!(:name => "Some type")
    end

    it "should delete type" do
      lambda do
        delete :destroy, :id => @type
      end.should change(Type, :count).by(-1)
    end

    it "should redirect to index page" do
      delete :destroy, :id => @type
      response.should redirect_to(types_path)
    end
  end
end
