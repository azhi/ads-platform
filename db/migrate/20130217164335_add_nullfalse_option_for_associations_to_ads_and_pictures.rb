class AddNullfalseOptionForAssociationsToAdsAndPictures < ActiveRecord::Migration
  def change
    change_column :advertisements, :type_id, :integer, :null => false
    change_column :advertisements, :user_id, :integer, :null => false
    change_column :pictures, :advertisement_id, :integer, :null => false
  end
end
