class AddOrdersubmittedToSitedata < ActiveRecord::Migration
  def change
    add_column :site_data, :ordersubmitted, :boolean
    add_column :site_data, :textsent, :boolean
  end
end
