class Operation < ActiveRecord::Base
    has_many :links
    has_many :categories, through: :links

    belongs_to :company

    validates :invoice_num, :invoice_date, :amount, :operation_date, :kind, :status, presence: true
    validates :amount, numericality: { greater_than: 0 }
    validates :invoice_num, uniqueness: true
end
