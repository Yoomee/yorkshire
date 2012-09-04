class AddAppFieldsToPages < ActiveRecord::Migration

  def change
    add_column :pages, :app_background, :string
    add_column :pages, :app_header, :string
    add_column :pages, :app_color, :string
  end

end
