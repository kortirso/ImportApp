require 'smarter_csv'

module Parser
    class TaskParser
        @@chunk_size = 1000

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
            SmarterCSV.process("#{Rails.root}/public#{@file}", chunk_size: @@chunk_size, encoding: 'utf-8', col_sep: ',') do |chunk|
                chunk.each { |row| parsing(row) }
                @total += chunk.size
                saving_operations
            end
            saving_operations
        end

        private
        def parsing(row)
            row[:kind] = '' if row[:kind].nil?
            return false unless row_valid?(row)
            company_id = find_company_index(row[:company].strip)
            return false if company_id.nil?
            operation = Operation.new task_id: @task_id, company_id: company_id, invoice_num: row[:invoice_num], invoice_date: transform_date(row[:invoice_date]), operation_date: transform_date(row[:operation_date]), amount: row[:amount].to_f, reporter: row[:reporter], status: row[:status], kind: row[:kind].downcase
            categories = row[:kind].downcase.split(';')
            categories.each { |cat| operation.links.build(category_id: find_category_index(cat)) }
            @operations << operation
        end

        def row_valid?(row)
            return false if row.size != 9
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