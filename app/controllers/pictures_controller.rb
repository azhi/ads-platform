class PicturesController < ApplicationController
  load_and_authorize_resource

  def create
    @picture.save
  end

  def destroy
    @picture.destroy
  end
end
