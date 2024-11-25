class CreateTestCases < ActiveRecord::Migration[7.0]
  def change
    create_table :test_cases do |t|
      t.references :problem, null: false, foreign_key: true
      t.text :input
      t.text :expected_output
      t.boolean :is_hidden

      t.timestamps
    end
  end
end
