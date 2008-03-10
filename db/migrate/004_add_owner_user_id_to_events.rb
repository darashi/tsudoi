class AddOwnerUserIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :owner_user_id, :integer
  end

  def self.down
    remove_column :events, :owner_user_id
  end
end
