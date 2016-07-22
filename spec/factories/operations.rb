FactoryGirl.define do
    factory :operation do
        sequence(:invoice_num) { |i| i }
        invoice_date Time.current
        amount 10000.0
        operation_date Time.current
        reporter 'John Doe'
        kind 'other'
        status 'other'
        association :company
        association :task
    end
end
