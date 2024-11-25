class CreateWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :weeks do |t|
      t.integer :number
      t.string :theme

      t.timestamps
    end
  end
end
