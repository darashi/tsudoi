class Entry < ActiveRecord::Base
  module STATUS
    WAITING_FOR_CONFIRMATION = "waiting_for_confirmation"
    CONFIRMED = "confirmed"
  end

  validates_presence_of     :nick, :email, :status
  validates_length_of       :nick, :within => 3..40
  validates_length_of       :email, :within => 3..100
  validates_uniqueness_of   :nick, :email, :case_sensitive => false
  belongs_to :event

  def before_validation
    self[:status] ||= Entry::STATUS::WAITING_FOR_CONFIRMATION
    self[:token] ||= ("%032x" % rand(2**128))
  end

  def activate
    update_attribute :status, Entry::STATUS::CONFIRMED
    @activated = true
  end

  def recently_activated?
    @activated
  end
end
