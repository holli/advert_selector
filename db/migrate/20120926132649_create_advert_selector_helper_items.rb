class CreateAdvertSelectorHelperItems < ActiveRecord::Migration
  def change
    create_table :advert_selector_helper_items do |t|
      t.integer :master_id
      t.string :master_type
      t.integer :position
      t.string :name
      t.boolean :content_for
      t.text :content

      t.timestamps
    end
  end
end
