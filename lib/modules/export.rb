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
                @operations.each do |operation|
                    csv << operation.attributes.values_at(*@column_names)
                end
            end
        end

        private
        def get_operations
            company = Company.find(@company_id)
            @operations = company.operations.of_task(@task_id)
            operations_filter
        end

        def operations_filter
            if @filter && @filter[:type] && !@filter[:text].empty?
                if %w(status invoice_num reporter).include?(@filter[:type])
                    @operations = @operations.where("#{@filter[:type]} = ?", @filter[:text])
                elsif @filter[:type] == 'kind'
                    category = Category.find_by(name: @filter[:text])
                    @operations = category.operations.where(company_id: @company_id, task_id: @task_id) if category
                end
            end
        end
    end
end