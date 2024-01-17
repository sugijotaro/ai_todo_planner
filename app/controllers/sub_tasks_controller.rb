class SubTasksController < ApplicationController
  before_action :set_task
  before_action :set_sub_task, only: [:show, :destroy]

  def show
  end

  def destroy
    @sub_task.destroy
    redirect_to task_path(@task), notice: 'Sub-task was successfully destroyed.'
  end
  
  def complete
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(completed: !@sub_task.completed)
    redirect_to task_path(@sub_task.task)
  end
  
  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_sub_task
    @sub_task = @task.sub_tasks.find(params[:id])
  end
end
