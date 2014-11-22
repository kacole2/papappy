class CreateSiteData < ActiveRecord::Migration
  def change
    create_table :site_data do |t|
      t.integer :inventory
      t.boolean :pappy
      t.string :pappyType

      t.timestamps
    end
  end
end
