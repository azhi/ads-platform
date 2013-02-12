class AddStateAndPublicationDateToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :state, :string
    add_column :advertisements, :published_at, :date
  end
end
