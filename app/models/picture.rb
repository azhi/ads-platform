class Picture < ActiveRecord::Base
  attr_accessible :url, :advertisement_id

  belongs_to :advertisement

  PICTURE_EXTENTIONS = %w(jpg jpeg png tiff tif gif bmp svg)
  URL_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\.(#{PICTURE_EXTENTIONS.join(?|)})\z/ix

  validates :url, :presence => true, :format => { :with => URL_REGEX }
end
