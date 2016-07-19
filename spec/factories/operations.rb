FactoryGirl.define do
    factory :operation do
        invoice_num 'B3963'
        invoice_date Time.current
        amount 10000
        operation_date Time.current
        kind 'Some kind'
        status 'Some status'
        association :company
    end
end
