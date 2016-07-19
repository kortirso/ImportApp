RSpec.describe Company, type: :model do
    it { should validate_presence_of :name }
    it { should have_many :operations }

    it 'should be valid' do
        company = create :company

        expect(company).to be_valid
    end
end
