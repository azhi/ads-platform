class Type < ActiveRecord::Base
  attr_accessible :name

  has_many :advertisements, :dependent => :destroy

  validates :name, :presence => true, :length => { :in => 2..20 }
end
