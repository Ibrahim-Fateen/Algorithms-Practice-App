class AddPostedToWeeks < ActiveRecord::Migration[7.0]
  def change
    add_column :weeks, :posted, :boolean
  end
end
