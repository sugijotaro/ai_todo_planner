class ChangeSubTasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :sub_tasks, :description, :text
    remove_column :sub_tasks, :due_date, :date
    remove_column :sub_tasks, :completed, :boolean
    add_column :sub_tasks, :content, :string
  end
end
