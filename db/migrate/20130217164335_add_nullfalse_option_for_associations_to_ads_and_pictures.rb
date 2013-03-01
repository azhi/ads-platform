class AddNullfalseOptionForAssociationsToAdsAndPictures < ActiveRecord::Migration
  def up
    change_column :advertisements, :type_id, :integer, :null => false
    change_column :advertisements, :user_id, :integer, :null => false
    change_column :pictures, :advertisement_id, :integer, :null => false
  end

  def down
    change_column :advertisements, :type_id, :integer
    change_column :advertisements, :user_id, :integer
    change_column :pictures, :advertisement_id, :integer
  end
end
