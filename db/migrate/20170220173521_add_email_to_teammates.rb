class AddEmailToTeammates < ActiveRecord::Migration[5.0]
  def change
    add_column :teammates, :email, :string
    add_column :teammates, :states, :boolean
  end
end
