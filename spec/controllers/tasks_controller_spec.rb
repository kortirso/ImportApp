RSpec.describe TasksController, type: :controller do
    describe 'GET #index' do
        let(:tasks) { create_list(:task, 2) }
        before { get :index }

        it 'collect an array of tasks' do
            expect(assigns(:tasks)).to match_array(tasks)
        end

        it 'renders index view' do
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        let(:task) { create :task }
        let(:operations) { create_list(:operation, 2, task: task) }
        let(:companies) { create_list(:company, 2) }

        context 'show exist task' do
            before { get :show, id: task }

            it 'assigns the requested task to @task' do
                expect(assigns(:task)).to eq task
            end

            it 'assigns all companies to @companies' do
                expect(assigns(:companies)).to eq companies
            end

            it 'assigns all operations in task to @operations' do
                expect(assigns(:operations)).to eq operations
            end

            it 'and renders show view' do
                expect(response).to render_template :show
            end
        end

        it 'but if task doesnt exist than render 404' do
            get :show, id: 1000

            expect(response).to render_template 'layouts/404'
        end
    end

    describe 'POST #create' do
        it 'redirects to tasks' do
            post :create, task: attributes_for(:task)

            expect(response).to redirect_to tasks_path
        end
    end
end
