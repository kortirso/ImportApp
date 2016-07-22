RSpec.describe ParsingTaskJob, type: :job do
    let(:task) { create :task }

    it 'should creates new parser' do
        expect(Parser::TaskParser).to receive(:new).with(task.file, task.id).and_call_original

        ParsingTaskJob.perform_now(task)
    end

    it 'and updates task' do
        expect(task).to receive(:update).and_call_original

        ParsingTaskJob.perform_now(task)
    end
end
