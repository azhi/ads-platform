class Admin::PagesController < ApplicationController
  def home
    raise CanCan::AccessDenied unless !current_user.nil? && current_user.role.admin?
  end
end
