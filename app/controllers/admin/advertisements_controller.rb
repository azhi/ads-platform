class Admin::AdvertisementsController < Admin::AdminController
  def all_new
    @advertisements = Advertisement.accessible_by(current_ability)
    @advertisements = @advertisements.all_new.
      include_associations.page(params[:page])
    render :template => "advertisements/index"
  end
end
