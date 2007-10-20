class Event < ActiveRecord::Base
  validates_presence_of :name, :date, :location, :description, :status
  belongs_to :owner, :class_name => "User", :foreign_key => :owner_user_id
  def before_validation
    self[:status] = "draft"
  end
end
