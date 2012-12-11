class AddLatitudeAndLongitudeToPages < ActiveRecord::Migration
  def change
    add_column :pages, :latitude, :string
    add_column :pages, :longitude, :string
  end
end
