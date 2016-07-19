FactoryGirl.define do
    factory :operation do
        sequence(:invoice_num) { |i| i }
        invoice_date Time.current
        amount 10000
        operation_date Time.current
        kind 'Some kind'
        status 'Some status'
        association :company
        association :task
    end
end
