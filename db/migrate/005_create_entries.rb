class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.column :nick, :string
      t.column :email, :string
      t.column :event_id, :integer
      t.column :status, :string
      t.column :token, :string
    end
  end

  def self.down
    drop_table :entries
  end
end
