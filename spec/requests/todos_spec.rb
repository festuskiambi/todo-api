require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
    # initialize test data
    let!(:todos) { create_list(:todo, 10) }
    
    let(:todo_id) { todos.first.id}

    # Test suite for GET /todos
    describe 'GET /todos' do
        # make HTTP get request before each example
        before { get '/todos' }
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
        before { get "/todos/#{todo_id}" }
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
        #valid payload
        let(:valid_attributes) { {title: 'Learn Node', created_by: '1' } }
        context 'when the request is valid' do
            before { post '/todos',params: valid_attributes }
            it 'creates a to do' do
                expect(json['title']).to eq('Learn Node')
            end
            it 'returns http code 201 ' do
                expect(response).to have_http_status(201)
            end       
        end
        context 'when the request is not valid' do
            before { post '/todos',params: { title: 'Learn React'} }
            it 'returns http code 422' do
                expect(response).to have_http_status(422)
            end 
            it ' returns a validation failure error' do
                expect(response.body).to match(/Validation failed: Created by can't be blank/)
            end      

        end       

    end 
    
    #Test suite for put/todos/:id
    describe 'PUT/todos/:id' do
        let(:valid_attributes)  { {title: 'something'} }
        context 'when record is exists' do
            before {put "/todos/#{todo_id}",params: valid_attributes }
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
        before {delete "/todos/#{todo_id}"}

        it 'it returns status code 204' do
            expect(response).to have_http_status(204)
        end    
    end    
end