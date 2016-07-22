RSpec.describe OperationsController, type: :controller do
    describe 'POST #create' do
        before { post :create, company_id: 1, task_id: 1, filter: '', format: :csv }

        it 'should return binary file' do
            expect(response.header['Content-Transfer-Encoding']).to eq 'binary'
        end

        it "and responce body should have titles in first line with ',' separator" do
            expect(response.body.chop).to eq 'invoice_num,amount,invoice_date,operation_date,reporter,kind,status'
        end

        context 'for valid data' do
            let(:operation) { create :operation }
            before { post :create, company_id: operation.company_id, task_id: operation.task_id, filter: { type: '', text: '' }, format: :csv }

            it "responce body should have data line with ',' separator with 7 parameters" do
                second_line = response.body[68..-1].chop.split(',')

                expect(second_line.size).to eq 7
            end

            it 'and it should be equal operation parameters' do
                second_line = response.body[68..-1].chop.split(',')

                expect(second_line[0]).to eq operation.invoice_num
                expect(second_line[1].to_f).to eq operation.amount
                expect(second_line[2].to_date).to eq operation.invoice_date
                expect(second_line[3].to_date).to eq operation.operation_date
                expect(second_line[4]).to eq operation.reporter
                expect(second_line[5]).to eq operation.kind
                expect(second_line[6]).to eq operation.status
            end
        end
    end
end
