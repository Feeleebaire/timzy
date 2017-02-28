class AddPhotoToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :photo, :string
  end
end
