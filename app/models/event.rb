class Event < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => :owner_user_id
  has_many :participations
  has_many :members, :through => :participations, :source => :user
  validates_presence_of :title, :deadline
  validates_uniqueness_of :title, :case_sensitive => false
  validates_format_of :url, :with => URI.regexp(['http', 'https']), :allow_nil => true
  validates_numericality_of :capacity, :allow_nil => true
  validates_each :published_at, :deadline do |model, attr, value|
    if value
      unless value.is_a? Time
        model.errors.add(attr, "には日付を入力してください")
      end
    end
  end

  def validate_on_update
    if valid_datetime?(deadline)
      if valid_datetime?(published_at) && (deadline <= published_at)
        errors.add(:published_at, "が正しくありません")
      end
    end
  end

  def validate
    errors.add(:deadline, "が正しくありません") if valid_datetime?(deadline) && (deadline <= Time.now)
    errors.add(:capacity, "が現在の参加人数を下回っています") if capacity_less_than_current_members?
    errors.add(:published_at, "既に参加表明された方がいるため未来日には変更できません") if participant_exist? && (published_at >= Time.now)
  end

  def before_save
    self.published_at = Time.now unless self.published_at
  end

  def can_register?
    (deadline >= Time.now) && (published_at <= Time.now) && in_capacity?
  end

  private

  def valid_datetime?(obj)
    obj && obj.is_a?(Time)
  end

  def participant_exist?
    !self.members.empty?
  end

  def effective_capacity?
    !self.capacity.nil?
  end

  def in_capacity?
    if effective_capacity?
      return self.members.size+1 <= self.capacity
    else
      return true
    end
  end

  def capacity_less_than_current_members?
    if effective_capacity?
      return self.capacity < self.members.size
    else
      return false
    end
  end

end
