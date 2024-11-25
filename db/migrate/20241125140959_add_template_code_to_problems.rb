class AddTemplateCodeToProblems < ActiveRecord::Migration[7.0]
  def change
    add_column :problems, :template_code, :text
  end
end
