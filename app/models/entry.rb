class Entry < ActiveRecord::Base
  validates_presence_of     :nick, :email, :status
  validates_length_of       :nick, :within => 3..40
  validates_length_of       :email, :within => 3..100
  validates_uniqueness_of   :nick, :email, :case_sensitive => false
  belongs_to :owner, :class_name => "Event", :foreign_key => :owner_event_id
end
