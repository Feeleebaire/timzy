class AddRefreshTokenToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :refresh_token, :string
  end
end
