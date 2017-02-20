class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :goal
      t.string :kpi
      t.string :category
      t.string :url_targeted
      t.references :user, foreign_key: true
      t.references :website, foreign_key: true

      t.timestamps
    end
  end
end
