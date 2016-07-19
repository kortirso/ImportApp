RSpec.describe Link, type: :model do
    it { should validate_presence_of :operation_id }
    it { should validate_presence_of :category_id }
    it { should belong_to :operation }
    it { should belong_to :category }

    it 'should be valid' do
        link = create :link

        expect(link).to be_valid
    end
end
