class OperationSerializer < ActiveModel::Serializer
    attributes :invoice_num, :invoice_date, :amount, :operation_date, :status, :company_id, :highest
end
