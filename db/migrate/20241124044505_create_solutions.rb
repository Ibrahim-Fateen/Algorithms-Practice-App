class CreateSolutions < ActiveRecord::Migration[7.0]
  def change
    create_table :solutions do |t|
      t.references :problem, null: false, foreign_key: true
      t.text :code, null: false
      t.string :time_complexity
      t.string :space_complexity

      t.timestamps
    end

    # Add an index to ensure one solution per problem
    # add_index :solutions, :problem_id, unique: true
  end
end