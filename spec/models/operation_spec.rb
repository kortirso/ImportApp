RSpec.describe Operation, type: :model do
    it { should validate_presence_of :invoice_num }
    it { should validate_presence_of :invoice_date }
    it { should validate_presence_of :operation_date }
    it { should validate_presence_of :amount }
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

    context '.highest' do
        let!(:operation_1) { create :operation }
        let!(:operation_2) { create :operation, amount: 20000.0 }

        it 'returns invoice_num of operation_2' do
            expect(Operation.highest).to eq operation_2.invoice_num
        end
    end

    context '.operations_filter' do
        let!(:company) { create :company }
        let!(:task) { create :task }
        let!(:category) { create :category, name: 'delegation' }
        let!(:operation_1) { create :operation, company: company, task: task }
        let!(:operation_2) { create :operation, amount: 20000.0, company: company, task: task, kind: 'delegation' }
        let!(:operation_3) { create :operation, amount: 20000.0, company: company, task: task, status: 'accepted' }
        let!(:link) { create :link, operation: operation_2, category: category }

        context 'return all operations if' do
            it 'no filter' do
                expect(Operation.operations_filter(nil).size).to eq 3
            end

            it 'filter[:type] is nil' do
                expect(Operation.operations_filter({ text: 'other' }).size).to eq 3
            end

            it 'filter[:text] is nil' do
                expect(Operation.operations_filter({ type: 'status' }).size).to eq 3
            end

            it 'filter[:text] is empty' do
                expect(Operation.operations_filter({ type: 'status', text: '' }).size).to eq 3
            end
        end

        context 'if filter is correct' do
            it 'returns operation with spesific kind' do
                expect(Operation.operations_filter({ type: 'kind', text: 'delegation' })).to eq [operation_2]
            end

            it 'returns operation with spesific status' do
                expect(Operation.operations_filter({ type: 'status', text: 'accepted' })).to eq [operation_3]
            end
        end
    end
end
