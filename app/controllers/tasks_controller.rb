class TasksController < ApplicationController
    before_action :find_task, only: :show

    def index
        @tasks = Task.order(id: :desc)
    end

    def show
        @companies = Company.all.order(id: :asc)
    end

    def create
        @task = Task.create(tasks_params)
        redirect_to tasks_path
    end

    private
    def find_task
        @task = Task.find_by(id: params[:id])
        render template: 'layouts/404', status: 404 if @task.nil?
    end

    def tasks_params
        params.require(:task).permit(:file)
    end
end
