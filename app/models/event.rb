class Event < ActiveRecord::Base
  validates_presence_of :name, :date, :location, :description, :status
  belongs_to :owner, :class_name => "User", :foreign_key => :owner_user_id
  has_many :owned_entries, :class_name => "Entry", :foreign_key => :owner_event_id
  validates_numericality_of :capacity, :only_integer => true, :allow_nil => true
  def validate
    if capacity && capacity <= 0
      errors.add(:capacity, "は1名以上を設定してください")
    end
  end
  def before_validation
    self[:status] = "draft"
  end
end
