class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    guest_rights
    send("#{@user.role}_rights") if @user.persisted?
  end

  def guest_rights
    can :read, Advertisement, :state => "published"
    can :show, User
  end

  def user_rights
    can [:read, :create, :destroy, :return_to_rough, :send_to_approval], Advertisement, :user_id => @user.id
    can :update, Advertisement, :user_id => @user.id, :state => "rough"
    can :manage, Picture
  end

  def admin_rights
    can [:read, :destroy, :return_to_rough, :approve, :reject], Advertisement
    cannot [:create, :update], Advertisement
    can :manage, [User, Type, Picture]
    can :set_role, User
    cannot [:update, :destroy, :set_role], User, :id => @user.id
  end
end
