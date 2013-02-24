class Admin::AdminController < ApplicationController
  before_filter :authorize_admin

  def authorize_admin
    raise CanCan::AccessDenied unless current_user && current_user.role.admin?
  end
end
