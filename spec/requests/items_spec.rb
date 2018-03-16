require 'rails_helper'

RSpec.describe'Items Api' do
    let!(:todo) { create(:todo) }
    let!(:items) { create_list(:item, 20, todo_id: todo.id) }
    let(:todo_id) { todo.id }
    let(:id) { items.first.id }

    describe 'GET /todos/:todo_id/items' do
        before { get "/todos/#{todo_id}/items" }
        context 'when todo exist' do
            it 'returns http status 200' do
                expect(response).to have_http_status(200)
            end
            it 'returns all todo items' do
                expect(json.size).to eq(20)
            end

        end
        context 'when todo does not exist' do
            let(:todo_id) { 0 }
            it 'returns http status 404' do
                expect(response).to have_http_status(404)
            end
            it 'returns not found error message' do
                expect(response.body).to match(/Couldn't find Todo/)
            end

        end        
    end 

    describe 'GET /todos/:todo_id/items/:id' do
        before {get "/todos/#{todo_id}/items/#{id}"}
        context 'when item exist' do
            it 'returns the todo' do
                expect(json['id']).to eq(id)
            end
            it 'returns http status 200' do
                expect(response).to have_http_status(200)
            end    

        end
        context 'when the item does not exist' do
            let(:id) { 0 }
            it 'returns http status 404' do
                expect(response).to have_http_status(404)
            end
            it ' returns error message' do
                expect(response.body).to match(/Couldn't find Item/)
            end

        end        

    end    
    
    describe 'POST/todos/:todo_id/items' do
        let(:valid_attributes) {{name: 'Fes', done: false }}
        context 'when request is valid' do
            before {post "/todos/#{todo_id}",params: valid_attributes}
            it 'returns http status 201' do
                expect(response).to have_http_status(201)
            end    
        end
        context 'when request is invalid' do
            before { post "/todos/#{todo_id}/items",params: {} }
            it 'returns  http status code 422' do
                expect(response).to have_http_status(422)
            end  
            it 'returns failure message' do
                expect(response.body).to match(/Validation failed: Name can't be blank/)
            end      
        end        
    end  
    
    describe 'PUT /todos/:todo_id/items/:id' do
        let(:valid_attributes) { {name: 'Test'}}
        context 'when request is valid' do
            before { put "/todos/#{todo_id}/items/#{id}" }
            it 'returns http status 204' do
                expect(response).to have_http_status(204)
            end 
            it 'updates the todo item' do
                updated_item = Item.find(id)
                expect(updated_item.name).to match(/Test/)

            end        
        end
        context 'when request is invalid' do
            let(:id) {0}
            it 'returns http status 404' do 
                expect(response).to have_http_status(404)
            end
            it 'returns failure message' do
                expect(response.body).to match(/Couldn't find Item/)
            end         
        end        
    end  
    
    describe 'DELETE /todos/:todi_id/items/:id' do
        before { delete "/todos/#{todo_id}/items/#{id}"}
        it 'returns http status 204' do
            expect(response).to have_http_status(204)
        end
    end    
end    