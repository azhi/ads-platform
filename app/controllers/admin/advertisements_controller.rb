class Admin::AdvertisementsController < Admin::AdminController
  def waiting_for_approval
    @advertisements = Advertisement.accessible_by(current_ability)
    @advertisements = @advertisements.waiting_for_approval.
      include_associations.page(params[:page])
    render :template => "advertisements/index"
  end
end
