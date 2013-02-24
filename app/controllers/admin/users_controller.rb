class Admin::UsersController < ApplicationController
  load_and_authorize_resource except: :set_role

  def index
  end

  def edit
  end

  def new
  end

  def create
    @user.skip_confirmation!
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to(@user)
    else
      render :action => "new"
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to(@user)
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy

    redirect_to(users_path)
  end

  def set_role
    @user = User.find(params[:id])
    authorize! :set_role, @user
    @user.role = params[:role]
    @user.save
  end
end
