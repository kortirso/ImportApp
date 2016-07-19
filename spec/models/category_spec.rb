RSpec.describe Category, type: :model do
    it { should validate_presence_of :name }
    it { should have_many(:links) }
    it { should have_many(:operations).through(:links) }

    it 'should be valid' do
        category = create :category

        expect(category).to be_valid
    end
end
