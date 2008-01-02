class Event < ActiveRecord::Base
  has_many :participations
  has_many :members, :through => :participations, :source => :user
end
