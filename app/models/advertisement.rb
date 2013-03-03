class Advertisement < ActiveRecord::Base
  attr_accessible :content, :type_id, :pictures_attributes
  attr_protected :user_id, :state, :published_at

  belongs_to :type
  has_many :pictures, :dependent => :destroy
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 2000 }
  validates :type, :presence => true
  validates :user, :presence => true

  accepts_nested_attributes_for :pictures, :reject_if => :all_blank,
                                :allow_destroy => true

  state_machine :initial => :rough do
    after_transition :approved => :published do |advertisement, transition|
      advertisement.published_at = Date.current
      advertisement.save
    end

    event :send_to_approval do
      transition :rough => :waiting_for_approval
    end

    event :return_to_rough do
      transition [:waiting_for_approval, :approved, :rejected, :published, :archived] => :rough
    end

    event :approve do
      transition :waiting_for_approval => :approved
    end

    event :reject do
      transition :waiting_for_approval => :rejected
    end

    event :publish do
      transition :approved => :published
    end

    event :archive do
      transition :published => :archived
    end
  end

  metaclass = class << self; self; end;
  state_machine.states.each do |st|
    block = Proc.new { where{ state == st.name.to_s } }
    define_method(st.name, &block)
    metaclass.send(:define_method, st.name, &block)
  end

  scope :accessible_by_and_belongs_to,
    lambda{ |ability, user| accessible_by(ability).where{ user_id == user.id } }
  scope :include_associations, includes(:type, :user, :pictures)
  scope :timed_out, where{ published_at <= Date.current - 3.days }

  def self.publish_approved
    approved.each do |ads|
      ads.publish
    end
  end

  def self.archive_published
    published.timed_out.each do |ads|
      ads.archive
    end
  end
end
