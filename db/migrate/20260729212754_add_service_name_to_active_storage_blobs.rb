class AddServiceNameToActiveStorageBlobs < ActiveRecord::Migration[8.0]
  def up
    add_column :active_storage_blobs, :service_name, :string
    ActiveStorage::Blob.unscoped.update_all(service_name: Rails.application.config.active_storage.service.to_s)
    change_column_null :active_storage_blobs, :service_name, false
  end

  def down
    remove_column :active_storage_blobs, :service_name
  end
end
