class RemovePhotoFromTeams < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :photo, :string
  end
end
