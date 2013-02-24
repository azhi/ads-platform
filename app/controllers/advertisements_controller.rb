class AdvertisementsController < ApplicationController
  load_and_authorize_resource except: [:transfer_state, :all_new]

  def index
    @advertisements = @advertisements.published.page(params[:page])
  end

  def all_new
    raise CanCan::AccessDenied unless !current_user.nil? && current_user.role.admin?
    @advertisements = @advertisements.all_new.page(params[:page])
    render :action => "index"
  end

  def new
    @advertisement.pictures.build
  end

  def show
  end

  def edit
  end

  def update
    if @advertisement.update_attributes(params[:advertisement])
      flash[:notice] = 'Advertisement was successfully updated.'
      redirect_to(@advertisement)
    else
      render :action => "edit"
    end
  end

  def create
    if @advertisement.save
      flash[:notice] = 'Your advertisement was successfully created.'
      redirect_to(@advertisement)
    else
      render :action => "new"
    end
  end

  def destroy
    @advertisement.destroy

    redirect_to(advertisements_path)
  end

  def transfer_state
    @advertisement = Advertisement.find(params[:id])
    authorize! params[:transfer_method].to_sym, @advertisement
    @advertisement.send(params[:transfer_method])
  end
end
