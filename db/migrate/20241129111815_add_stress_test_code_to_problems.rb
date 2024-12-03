class AddStressTestCodeToProblems < ActiveRecord::Migration[7.0]
  def change
    add_column :problems, :stress_test_code, :text
  end
end
