class CreateAdvertSelectorPlacements < ActiveRecord::Migration
  def change
    create_table :advert_selector_placements do |t|
      t.string :name, :null => false
      #t.text :development_code
      t.integer :request_delay
      t.text :conflicting_placements_array

      t.timestamps
    end
  end
end
