class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      create_sub_tasks(@task)
      redirect_to @task, notice: 'タスクが正常に作成されました。'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'タスクが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'タスクが正常に削除されました。'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end
  
  def create_sub_tasks(task)
    sub_tasks_str = OpenaiClient.generate_sub_tasks(task.title, task.description)
    Rails.logger.info "OpenAI API Response: #{sub_tasks_str}"

    begin
      sub_tasks_array = JSON.parse(sub_tasks_str)
    rescue JSON::ParserError => e
      Rails.logger.error "JSON Parsing error: #{e.message}"
      return
    end

    sub_tasks_array.each do |sub_task_content|
      task.sub_tasks.create(content: sub_task_content, completed: false)
    end
  end
end
