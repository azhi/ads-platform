class AddManyToManyConnectionBetweenPicturesAndAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements_pictures do |t|
      t.integer :advertisement_id
      t.integer :picture_id
    end
  end
end
