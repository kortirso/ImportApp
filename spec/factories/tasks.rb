FactoryGirl.define do
    factory :task do
        file File.open(File.join(Rails.root, 'db/ImporterAppExample.csv'))
    end
end
