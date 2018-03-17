require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
    # initialize test data
    let(:user) { create(:user) }
    let!(:todos) { create_list(:todo, 10, created_by: user.id) }
    let(:todo_id) { todos.first.id }
    # authorize request
    let(:headers) { valid_headers }

    # Test suite for GET /todos
    describe 'GET /todos' do
        # make HTTP get request before each example
        before { get '/todos', params: {}, headers: headers }

        it 'returns todos' do
             # Note `json` is a custom helper to parse JSON responses
            expect(json).not_to be_empty 
            expect(json.size).to eq(10)
        end 
        it 'returns code 200' do
            expect(response).to have_http_status(200)
        end

    end 
     
    describe 'GET /todos/:id' do
        before { get "/todos/#{todo_id}", params: {}, headers: headers }
        context 'when the record exist' do
            it 'returns the todo' do
                expect(json).not_to be_empty
                
            end
            it 'returns code 200' do
                expect(response).to have_http_status(200)
            end        
        end
        context 'when the recoerd doesnt exist' do   
            let (:todo_id) { 100 }
            it 'returns http status code 404' do
                expect(response).to have_http_status(404)
            end
            it 'returns not found message' do
                expect(response.body).to match(/Couldn't find Todo/)
            end 
        end       
    end 
    
    #Test suite for post/todos
    describe 'POST/todos' do
        let(:valid_attributes) do
            # send json payload
            { title: 'Learn Node', created_by: user.id.to_s }.to_json
        end
        context 'when the request is valid' do
            before { post '/todos', params: valid_attributes, headers: headers }
            it 'creates a to do' do
                expect(json['title']).to eq('Learn Node')
            end
            it 'returns http code 201 ' do
                expect(response).to have_http_status(201)
            end       
        end
        context 'when the request is not valid' do
            let(:invalid_attributes) { { title: nil }.to_json }
            before { post '/todos', params: invalid_attributes, headers: headers }
            it 'returns http code 422' do
                expect(response).to have_http_status(422)
            end 
            it ' returns a validation failure error' do
                expect(response.body).to match(/Validation failed: Title can't be blank/)
            end      

        end       

    end 
    
    #Test suite for put/todos/:id
    describe 'PUT/todos/:id' do
        let(:valid_attributes) { { title: 'Shopping' }.to_json }
        context 'when record is exists' do
            before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers }
            it 'updates the record ' do
                expect(response.body).to be_empty
            end    
            it 'returns status code 204' do
                expect(response).to have_http_status(204)
            end    

        end              

    end 
  
    
    #Test suite for DELETE/todos/:id
    describe 'DELETE/todos/:id' do
        before { delete "/todos/#{todo_id}", params: {}, headers: headers }

        it 'it returns status code 204' do
            expect(response).to have_http_status(204)
        end    
    end    
end