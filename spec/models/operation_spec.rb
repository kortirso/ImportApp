RSpec.describe Operation, type: :model do
    it { should validate_presence_of :invoice_num }
    it { should validate_presence_of :invoice_date }
    it { should validate_presence_of :operation_date }
    it { should validate_presence_of :amount }
    it { should validate_presence_of :kind }
    it { should validate_presence_of :status }
    it { should validate_presence_of :company_id }
    it { should validate_presence_of :task_id }
    it { should have_many :links }
    it { should have_many(:categories).through(:links) }
    it { should belong_to :company }
    it { should belong_to :task }
    it { should validate_numericality_of(:amount).is_greater_than(0) }

    it 'should be valid' do
        operation = create :operation

        expect(operation).to be_valid
    end
end
