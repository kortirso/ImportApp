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

    #after_create :send_message

    def self.highest
        all.order(amount: :desc).first.invoice_num
    end

    private
    def send_message
        PrivatePub.publish_to "/tasks/#{self.task_id}", operation: OperationSerializer.new(self).serializable_hash.to_json
    end
end
