require 'rails_helper'

RSpec.describe 'Bedeles', type: :request do
  scenario 'Sends a post request to create a bedel' do
    post 'http://localhost:3000/bedeles', params: { apellido: 'test_apellido', id: 'tt1', nombre: 'test_nombre', password: '12345678', turno: 'mañana' }

    expect(response).to have_http_status(:success)
    post = JSON.parse(response.body)
    expect(post['apellido']).to eq('Test_apellido')
    expect(post['id']).to eq('tt1')
    expect(post['nombre']).to eq('Test_nombre')
    expect(post['turno']).to eq('mañana')
  end
end
