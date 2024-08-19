require 'rails_helper'

RSpec.describe 'Bedeles', type: :request do
  before do
    Bedel.create!(id: 'tt1', turno: 'mañana', nombre: 'test_nombre', apellido: 'test_apellido', password: '12345678')
  end
  scenario 'Sends a put request to update bedel' do
    put 'http://localhost:3000/bedeles/tt1', params: { apellido: 'prueba_apellido', nombre: 'prueba_nombre', turno: 'tarde' }

    expect(response).to have_http_status(:success)
    post = JSON.parse(response.body)
    expect(post['apellido']).to eq('Prueba_apellido')
    expect(post['nombre']).to eq('Prueba_nombre')
    expect(post['turno']).to eq('tarde')
    bedel = Bedel.find('tt1')
    expect(bedel.turno).to eq('tarde')
    expect(bedel.nombre).to eq('Prueba_nombre')
    expect(bedel.apellido).to eq('Prueba_apellido')
  end
  scenario 'Send put request to update bedel with invalid id' do
    put 'http://localhost:3000/bedeles/tt2', params: { apellido: 'prueba_apellido', nombre: 'prueba_nombre', turno: 'tarde' }

    expect(response).to have_http_status(:not_found)
  end
  scenario 'Send put request to update bedel\'s password' do
    put 'http://localhost:3000/bedeles/tt1', params: { password: '87654321' }

    expect(response).to have_http_status(:success)
    bedel = Bedel.find('tt1')
    expect(bedel.authenticate('87654321')).to eq(bedel)
    expect(bedel.authenticate('12345678')).to eq(false)
  end
end
