class AddTeamIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :team, foreign_key: true
    remove_reference :projects, :website
  end
end
