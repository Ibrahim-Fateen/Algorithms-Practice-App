class CreateSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :problem, null: false, foreign_key: true
      t.text :code
      t.integer :status
      t.jsonb :test_results

      t.timestamps
    end
  end
end
