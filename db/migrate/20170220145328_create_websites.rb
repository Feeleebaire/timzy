class CreateWebsites < ActiveRecord::Migration[5.0]
  def change
    create_table :websites do |t|
      t.string :name
      t.string :url
      t.references :analytic, foreign_key: true
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
