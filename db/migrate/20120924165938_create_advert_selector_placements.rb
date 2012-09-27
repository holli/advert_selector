class CreateAdvertSelectorPlacements < ActiveRecord::Migration
  def change
    create_table :advert_selector_placements do |t|
      t.string :name, :null => false
      #t.text :development_code
      t.boolean :only_once_per_session
      t.text :conflicting_placements_array

      t.timestamps
    end
  end
end
