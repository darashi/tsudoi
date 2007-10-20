class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :name, :string
      t.column :time, :datetime
      t.column :location, :string
      t.column :description, :text
      t.column :deadline, :time
      t.column :capacity, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :status, :string

      t.column :owner_user_id, :integer
    end
  end

  def self.down
    drop_table :events
  end
end
