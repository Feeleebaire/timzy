class AddNameToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :name, :string
  end
end
