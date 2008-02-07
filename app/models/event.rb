class Event < ActiveRecord::Base
  has_many :participations
  has_many :members, :through => :participations, :source => :user
  validates_presence_of :title, :deadline
  validates_uniqueness_of :title, :case_sensitive => false
end
