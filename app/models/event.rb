class Event < ActiveRecord::Base
  module STATUS
    DRAFT = "draft"
  end

  validates_presence_of :name, :time, :location, :description, :status
  belongs_to :owner, :class_name => "User", :foreign_key => :owner_user_id
  has_many :entries
  has_many :confirmed_entries, :class_name => "Entry",
    :conditions => {:status => Entry::STATUS::CONFIRMED}
  validates_numericality_of :capacity, :only_integer => true, :allow_nil => true

  def validate
    if capacity && capacity <= 0
      errors.add(:capacity, "は1名以上を設定してください")
    end
  end

  def before_validation
    self[:status] ||= Event::STATUS::DRAFT
  end
end
