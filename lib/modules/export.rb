require 'csv'

module Export
    class OperationsExport
        def initialize(company_id, task_id, filter)
            @company_id = company_id
            @task_id = task_id
            @filter = filter
            @options = { col_sep: ",", encoding: 'utf-8' }
            @column_names = %w(invoice_num amount invoice_date operation_date reporter kind status)
            @operations = nil
        end

        def build_csv
            get_operations
            CSV.generate(@options) do |csv|
                csv << @column_names
                @operations.each { |operation| csv << operation.attributes.values_at(*@column_names) } if @operations
            end
        end

        private
        def get_operations
            company = Company.find_by(id: @company_id)
            if company
                @operations = company.operations.of_task(@task_id)
                @operations = @operations.operations_filter(@filter ,@company_id, @task_id)
            end
        end
    end
end