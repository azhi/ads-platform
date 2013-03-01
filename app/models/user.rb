class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable

  extend Enumerize

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :nickname
  attr_protected :role

  has_many :advertisements, :dependent => :destroy

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :nickname, :presence => true, :length => { :within => 4..25 }
  validates :email, :presence => true, :format => { :with => EMAIL_REGEX }

  enumerize :role, in: [:user, :admin], default: :user
end
