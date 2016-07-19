FactoryGirl.define do
    factory :link do
        association :operation
        association :category
    end
end
