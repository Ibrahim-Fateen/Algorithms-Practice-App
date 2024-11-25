class CreateHints < ActiveRecord::Migration[7.0]
  def change
    create_table :hints do |t|
      t.references :problem, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :order_number, null: false

      t.timestamps
    end

    # Add an index for efficient ordering of hints
    add_index :hints, [:problem_id, :order_number]
  end
end