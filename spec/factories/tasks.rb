FactoryGirl.define do
    factory :task do
        file File.open(File.join(Rails.root, 'db/ImporterAppExampleSmall.csv'))
    end
end
