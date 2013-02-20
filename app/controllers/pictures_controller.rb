class PicturesController < ApplicationController
  load_and_authorize_resource

  def create
    render :action => "new" unless @picture.save
  end

  def update
    render :action => "edit" unless @picture.update_attributes(params[:picture])
  end

  def destroy
    @picture.destroy
  end
end
