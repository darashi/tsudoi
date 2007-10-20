class CreateUsers < ActiveRecord::Migration
  def self.up
    options = {
     :options => "DEFAULT CHARSET=utf8" # 日本語対応にする
    }
    create_table :users, options do |t|
      t.column :name, :string
      t.column :mail, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
