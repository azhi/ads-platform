class PicturesController < ApplicationController
  def create
    @pic = Picture.new(params[:picture])
    render :action => "new" unless @pic.save
  end

  def update
    @pic = Picture.find(params[:id])
    render :action => "edit" unless @pic.update_attributes(params[:picture])
  end

  def destroy
    @pic = Picture.find(params[:id])
    @pic.destroy
  end
end
