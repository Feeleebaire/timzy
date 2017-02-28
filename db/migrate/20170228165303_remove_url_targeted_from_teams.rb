class RemoveUrlTargetedFromTeams < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :url_targeted, :string
  end
end
