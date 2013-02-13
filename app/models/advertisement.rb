class Advertisement < ActiveRecord::Base
  attr_accessible :content, :published_at, :type_id, :pictures_attributes

  belongs_to :type
  has_many :pictures, :dependent => :destroy

  validates :content, :presence => true, :length => { :maximum => 2000 }

  accepts_nested_attributes_for :pictures, :reject_if => :all_blank,
                                :allow_destroy => true

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

    event :transfer_to_archive do
      transition :published => :archived
    end
  end
end
