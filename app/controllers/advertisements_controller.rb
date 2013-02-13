class AdvertisementsController < ApplicationController
  def index
    @all_ads = Advertisement.all
  end

  def new
    @ads = Advertisement.new
    @ads.pictures.build
  end

  def show
    @ads = Advertisement.find(params[:id])
  end

  def edit
    @ads = Advertisement.find(params[:id])
  end

  def update
    @ads = Advertisement.find(params[:id])

    if @ads.update_attributes(params[:advertisement])
      flash[:notice] = 'Advertisement was successfully updated.'
      redirect_to(@ads)
    else
      render :action => "edit"
    end
  end

  def create
    @ads = Advertisement.new(params[:advertisement])

    if @ads.save
      flash[:notice] = 'Your advertisement was successfully created.'
      redirect_to(@ads)
    else
      render :action => "new"
    end
  end

  def destroy
    @ads = Advertisement.find(params[:id])
    @ads.destroy

    redirect_to(advertisements_path)
  end
end
