class AddActivationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_code, :string, :limit => 40
    add_column :users, :activated_at, :datetime

    User.find(:all).each do |user|
      if user.activated_at.blank?
        user.update_attribute :activated_at, Time.now
      end
    end
  end

  def self.down
    remove_column :users, :activation_code
    remove_column :users, :activated_at
  end
end
