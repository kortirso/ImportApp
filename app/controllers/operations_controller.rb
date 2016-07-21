class OperationsController < ApplicationController
    def create
        exporter = Export::OperationsExport.new(params[:company_id].to_i, params[:task_id].to_i, params[:filter])
        respond_to do |format|
            format.csv { send_data exporter.build_csv }
        end
    end
end
