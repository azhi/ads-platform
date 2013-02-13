class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :url
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
