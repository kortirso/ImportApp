class TasksController < ApplicationController
    #before_action :find_task, only: :show

    def index
        @tasks = Task.order(id: :desc)
    end

    def show
        #@words = @task.words.completed.order(name: :asc).includes(:links)
        #respond_with @task
    end

    def create
        @task = Task.create(tasks_params)
        redirect_to tasks_path
    end

    private
    def find_task
        @task = current_user.tasks.find_by(id: params[:id])
        render template: 'layouts/404', status: 404 unless @task
    end

    def tasks_params
        params.require(:task).permit(:file)
    end
end
