FactoryGirl.define do
    factory :company do
        sequence(:name) { |i| "Company_#{i}" }
    end
end
