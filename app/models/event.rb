class Event < ActiveRecord::Base
  validates_presence_of :name, :date, :location, :description, :status
  def before_validation
    self[:status] = "draft"
  end
end
