class Event < ActiveRecord::Base
  has_many :participations
  has_many :members, :through => :participations, :source => :user
  validates_presence_of :title, :deadline
  validates_uniqueness_of :title, :case_sensitive => false
  validates_format_of :url, :with => URI.regexp(['http', 'https']), :allow_nil => true
  validates_each :published_at, :deadline do |model, attr, value|
    if value
      unless value.is_a? Time
        model.errors.add(attr, "には日付を入力してください")
      end
    end
  end

  def validate_on_update
    if date?(deadline)
      if date?(published_at) && (deadline <= published_at)
        errors.add(:published_at, "が正しくありません")
      end
    end
  end

  def validate
    errors.add(:deadline, "が正しくありません") if date?(deadline) && (deadline <= Time.now)
  end

  def before_save
    self.published_at = Time.now unless self.published_at
  end

  private

  def date?(obj)
    obj && obj.respond_to?("to_date")
  end

end
