class Picture < ActiveRecord::Base
  attr_accessible :url

  has_and_belongs_to_many :advertisements

  PICTURE_EXTENTIONS = %w(jpg jpeg png tiff tif gif bmp svg)
  URL_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\.(#{PICTURE_EXTENTIONS.join(?|)})\z/ix

  validates :url, :presence => true, :format => { :with => URL_REGEX }
end
