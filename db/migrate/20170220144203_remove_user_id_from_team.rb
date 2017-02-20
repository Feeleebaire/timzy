class RemoveUserIdFromTeam < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :user_id
    add_reference :teams, :admin, index: true
    add_foreign_key :teams, :users, column: :admin_id
  end
end
