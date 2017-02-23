class AddAccountToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :accountid, :string
    add_column :teams, :webproprietyid, :string
    add_column :teams, :view_id, :string
    add_column :teams, :view_name, :string
  end
end
