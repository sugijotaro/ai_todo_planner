class UpdateSubTasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :sub_tasks, :title, :string
    add_column :sub_tasks, :completed, :boolean, default: false
  end
end
