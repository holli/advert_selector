class CreateAdvertSelectorBanners < ActiveRecord::Migration
  def change
    create_table :advert_selector_banners do |t|
      t.string :name, :null => false
      t.datetime :start_time
      t.datetime :end_time
      t.integer :priority, :null => false, :default => 0
      t.integer :target_view_count
      t.integer :running_view_count, :null => false, :default => 0
      t.integer :frequency
      t.boolean :fast_mode, :null => false, :default => false
      t.text :comment
      t.boolean :confirmed, :null => false, :default => false
      t.integer :placement_id, :null => false

      t.timestamps
    end
  end
end
