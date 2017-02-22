class AddAnalyticsIdToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :url_targeted, :string
    add_reference :teams, :analytic, foreign_key: true
  end
e
