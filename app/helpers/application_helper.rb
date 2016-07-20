module ApplicationHelper
    def operations_filter(operations, filter, company_id, task_id)
        if filter && filter[:type] && !filter[:text].empty?
            if %w(status invoice_num reporter).include?(filter[:type])
                operations = operations.where("#{filter[:type]} = ?", filter[:text])
            elsif filter[:type] == 'kind'
                category = Category.find_by(name: filter[:text])
                if category
                    operations = category.operations.where(company_id: company_id, task_id: task_id)
                end
            end
        end
        operations
    end
end
