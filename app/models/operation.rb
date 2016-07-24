class Operation < ActiveRecord::Base
    has_many :links, dependent: :destroy
    has_many :categories, through: :links

    belongs_to :company
    belongs_to :task

    validates :invoice_num, :invoice_date, :amount, :operation_date, :status, :company_id, :task_id, presence: true
    validates :amount, numericality: { greater_than: 0 }
    validates :invoice_num, uniqueness: true

    scope :of_task, -> (task_id) { where(task_id: task_id) }
    scope :of_company, -> (company_id) { where(company_id: company_id) }
    scope :accepted, -> { where(status: 'accepted') }

    def self.highest
        all.order(amount: :desc).first.invoice_num
    end

    def self.operations_filter(filter, company_id, task_id)
        operations = all
        if filter && filter[:type] && filter[:text] && !filter[:text].empty?
            if %w(status invoice_num reporter).include?(filter[:type])
                operations = operations.where("#{filter[:type]} = ?", filter[:text])
            elsif filter[:type] == 'kind'
                category = Category.find_by(name: filter[:text])
                operations = category.operations.where(company_id: company_id, task_id: task_id) if category
            end
        end
        operations
    end
end
