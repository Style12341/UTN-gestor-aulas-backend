require 'rails_helper'

RSpec.describe 'Bedeles', type: :request do
  before do
    Bedel.create!(id: 'tt1', turno: 'mañana', nombre: 'test_nombre', apellido: 'test_apellido', password: '12345678')
    Bedel.create!(id: 'tt2', turno: 'mañana', nombre: 'test_nombre1', apellido: 'test_apellido1', password: '12345678')
  end

  scenario 'Sends a delete request to delete a bedel' do
    delete 'http://localhost:3000/bedeles/tt1'
    expect(response).to have_http_status(:success)

    get 'http://localhost:3000/bedeles'

    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.length).to eq(1)
  end
end
