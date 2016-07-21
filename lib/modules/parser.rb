require 'csv'

module Parser
    class TaskParser
        def initialize(file, task_id)
            @file = file
            @task_id = task_id
            @success = 0
            @failure = 0
            @companies = get_companies
            @categories = get_categories
        end

        attr_reader :success, :failure

        def parse_file
            CSV.read("#{Rails.root}/public#{@file}", encoding: 'utf-8', col_sep: ',')[1..-1].each_with_index do |row, index|
                parsing(row)
                send_message if index % 50 == 0
            end
            send_message
        end

        private

        def send_message
            PrivatePub.publish_to "/tasks", operations: { task_id: @task_id, success: @success, failure: @failure }.to_json
        end

        def parsing(row)
            company_id = find_company_index(row[0].strip)
            return @failure += 1 if company_id.nil?
            operation = Operation.create(task_id: @task_id, company_id: company_id, invoice_num: row[1], invoice_date: transform_date(row[2]), operation_date: transform_date(row[3]), amount: row[4].to_f, reporter: row[5], status: row[7], kind: row[8].downcase, highest: (highest?(row[4].to_f, company_id) ? true : false))
            check_categories(operation.id, row[8])
            @success += 1
        rescue
            @failure += 1
        end

        def transform_date(date)
            if date[2] == '/'
                dates = date.split('/')
                date = "#{dates[1]}-#{dates[0]}-#{dates[2]}"
            end
            return date.to_date
        end

        def get_companies
            Company.all.map { |c| [c.name, c.id, 0] }
        end

        def get_categories
            Category.all.map { |c| [c.name, c.id] }
        end

        def find_company_index(company_name)
            company = @companies.select { |c| c[0] == company_name }
            if company.empty?
                return nil
            else
                return company.flatten[1].to_i
            end
        end

        def check_categories(operation_id, kinds)
            categories = kinds.downcase.split(';')
            categories.each do |cat|
                category_id = find_category_index(cat)
                Link.create category_id: category_id, operation_id: operation_id
            end
        end

        def find_category_index(category_name)
            category = @categories.select { |c| c[0] == category_name }
            if category.empty?
                category = Category.create(name: category_name)
                @categories.push([category.name, category.id])
                return category.id
            else
                return category.flatten[1].to_i
            end
        end

        def highest?(operation_amount, company_id)
            if operation_amount > @companies[company_id - 1][2]
                old = Operation.find_by(task_id: @task_id, company_id: company_id, highest: true)
                old.update(highest: false) unless old.nil?
                @companies[company_id - 1][2] = operation_amount
                return true
            else
                return false
            end
        end
    end
end