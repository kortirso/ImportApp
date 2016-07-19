RSpec.describe Operation, type: :model do
    it { should validate_presence_of :invoice_num }
    it { should validate_presence_of :invoice_date }
    it { should validate_presence_of :operation_date }
    it { should validate_presence_of :amount }
    it { should validate_presence_of :kind }
    it { should validate_presence_of :status }
    it { should have_many(:links) }
    it { should have_many(:categories).through(:links) }

    it 'should be valid' do
        operation = create :operation

        expect(operation).to be_valid
    end
end
