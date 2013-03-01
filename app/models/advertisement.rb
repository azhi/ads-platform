class Advertisement < ActiveRecord::Base
  attr_accessible :content, :published_at, :type_id, :pictures_attributes
  attr_protected :user_id

  belongs_to :type
  has_many :pictures, :dependent => :destroy
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 2000 }
  validates :type, :presence => true
  validates :user, :presence => true

  accepts_nested_attributes_for :pictures, :reject_if => :all_blank,
                                :allow_destroy => true

  scope :published, where{state == 'published'}
  scope :all_new, where{state == 'new'}
  scope :accessible_by_and_belongs_to,
    lambda{ |ability, user| accessible_by(ability).where{user_id == user.id} }
  scope :include_associations, includes(:type, :user, :pictures)

  def self.publish_approved
    where{ state == "approved" }.each do |ads|
      ads.publish
    end
  end

  def self.archive_published
    where{ (state == "published") & (published_at <= Date.current - 3.days) }.each do |ads|
      ads.archive
    end
  end

  state_machine :initial => :rough do
    after_transition :approved => :published do |advertisement, transition|
      advertisement.published_at = Date.current
      advertisement.save
    end

    event :send_to_approval do
      transition :rough => :new
    end

    event :return_to_rough do
      transition [:new, :approved, :rejected, :published, :archived] => :rough
    end

    event :approve do
      transition :new => :approved
    end

    event :reject do
      transition :new => :rejected
    end

    event :publish do
      transition :approved => :published
    end

    event :archive do
      transition :published => :archived
    end
  end
end
