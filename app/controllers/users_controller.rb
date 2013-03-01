class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @advertisements = Advertisement.
      accessible_by_and_belongs_to(current_ability, @user).
      include_associations.page(params[:page])
  end
end
