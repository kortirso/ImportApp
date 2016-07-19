RSpec.describe Task, type: :model do
    it { should have_many :operations }
    it { should validate_presence_of :file }

    it 'should be valid' do
        task = create :task

        expect(task).to be_valid
    end
end
