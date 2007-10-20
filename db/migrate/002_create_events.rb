class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :name, :string
      t.column :location, :string
      t.column :date, :date
      t.column :deadline, :date
      t.column :description, :text
      t.column :state, :string
      t.column :capacity, :integer
      t.column :created_at, :date
      t.column :updated_at, :date
    end
  end

  def self.down
    drop_table :events
  end
end
