class AddPositionPaperUrlToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :position_paper_url, :string
  end

  def self.down
    remove_column :events, :position_paper_url
  end
end
