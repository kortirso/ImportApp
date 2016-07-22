RSpec.describe Task, type: :model do
    it { should have_many :operations }
    it { should validate_presence_of :file }

    it 'should be valid' do
        task = create :task

        expect(task).to be_valid
    end

    context '.parsing_task' do
        subject { build :task }

        it 'should perform_later job ParsingTaskJob' do
            expect(ParsingTaskJob).to receive(:perform_later).with(subject)
            subject.save!
        end
    end
end
