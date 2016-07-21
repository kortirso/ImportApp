require 'csv'

module Parser
    class TaskParser
        def initialize(file, task_id)
            @file = file
            @task_id = task_id
            @total = 0
            @success = 0
            @companies = get_companies
            @categories = get_categories
            @operations = []
        end

        attr_reader :success, :total

        def parse_file
            CSV.read("#{Rails.root}/public#{@file}", encoding: 'utf-8', col_sep: ',')[1..-1].each do |row|
                parsing(row)
                @total += 1
                saving_operations if @total % 200 == 0
            end
            saving_operations
        end

        private
        def parsing(row)
            return false unless row_valid?(row)
            company_id = find_company_index(row[0].strip)
            return false if company_id.nil?
            operation = Operation.new task_id: @task_id, company_id: company_id, invoice_num: row[1], invoice_date: transform_date(row[2]), operation_date: transform_date(row[3]), amount: row[4].to_f, reporter: row[5], status: row[7], kind: row[8].downcase
            categories = row[8].downcase.split(';')
            categories.each { |cat| operation.links.build(category_id: find_category_index(cat)) }
            @operations << operation
        end

        def row_valid?(row)
            (0..8).each { |index| return false if row[index].nil? }
            return true
        end

        def saving_operations
            saved = Operation.import @operations, recursive: true
            @operations = []
            @success += saved.ids.count
            send_message
        end

        def send_message
            PrivatePub.publish_to "/tasks", operations: { task_id: @task_id, success: @success, failure: @total - @success }.to_json
        end

        def transform_date(date)
            if date
                if date[2] == '/'
                    dates = date.split('/')
                    date = "#{dates[1]}-#{dates[0]}-#{dates[2]}"
                end
                date = '' if date == 'N/A'
                return date.to_date
            else
                return ''.to_date
            end
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
    end
end