class Operation < ActiveRecord::Base
    has_many :links
    has_many :categories, through: :links

    belongs_to :company
    belongs_to :task

    validates :invoice_num, :invoice_date, :amount, :operation_date, :kind, :status, :company_id, :task_id, presence: true
    validates :amount, numericality: { greater_than: 0 }
    validates :invoice_num, uniqueness: true
end
