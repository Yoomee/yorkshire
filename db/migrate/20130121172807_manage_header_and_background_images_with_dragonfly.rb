class ManageHeaderAndBackgroundImagesWithDragonfly < ActiveRecord::Migration
  def up
    add_column :pages, :header_image_uid, :string
    Page.reset_column_information
    Page.all.each do |page|
      if page.app_header.present?
        page.header_image = File.read(File.join(Rails.root, "app/assets/images/header_#{page.app_header}.jpg"))
        page.save
      end
    end
    remove_column :pages, :app_header
  end
end
