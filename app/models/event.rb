class Event < ActiveRecord::Base
  has_many :participations
  has_many :members, :through => :participations, :source => :user
  validates_presence_of :title, :deadline
  validates_uniqueness_of :title, :case_sensitive => false
  validates_format_of :url, :with => URI.regexp(['http', 'https']), :allow_nil => true
  validates_each :published_at, :deadline do |model, attr, value|
    unless value.is_a? DateTime
      model.errors.add(attr, "には日付を入力してください")
    end
  end
end
