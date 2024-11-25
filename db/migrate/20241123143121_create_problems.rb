class CreateProblems < ActiveRecord::Migration[7.0]
  def change
    create_table :problems do |t|
      t.string :title
      t.text :description
      t.string :difficulty
      t.references :week, null: false, foreign_key: true

      t.timestamps
    end
  end
end
