class CreateAdvertSelectorHelperItems < ActiveRecord::Migration
  def change
    create_table :advert_selector_helper_items do |t|
      t.integer :banner_id

      #t.references :master, :polymorphic => true

      t.integer :position
      t.string :name
      t.boolean :content_for
      t.text :content

      t.timestamps
    end

    add_index(:advert_selector_helper_items, [:banner_id, :position], :name => 'index_banner_position')
  end
end
