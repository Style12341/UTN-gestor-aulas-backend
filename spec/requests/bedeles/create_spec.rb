require 'rails_helper'

RSpec.describe 'Bedeles', type: :request do
  scenario 'Sends a post request to create a bedel' do
    post 'http://localhost:3000/bedeles', params: { apellido: 'test_apellido', id: 'tt1', nombre: 'test_nombre', password: '12&A45678', turno: 'mañana' }

    expect(response).to have_http_status(:success)
    post = JSON.parse(response.body)
    expect(post['apellido']).to eq('Test_apellido')
    expect(post['id']).to eq('tt1')
    expect(post['nombre']).to eq('Test_nombre')
    expect(post['turno']).to eq('mañana')
  end
  scenario 'Sends a post request to create a bedel and password fails condition length' do
    post 'http://localhost:3000/bedeles', params: { apellido: 'test_apellido', id: 'tt1', nombre: 'test_nombre', password: '12&A67', turno: 'mañana' }

    expect(response).to have_http_status(:unprocessable_entity)
    post = JSON.parse(response.body)
    expect(post['error']).to eq(['La contraseña debe tener por lo menos 8 caracteres'])
  end
  scenario 'Sends a post request to create a bedel and password fails condition special character' do
    post 'http://localhost:3000/bedeles', params: { apellido: 'test_apellido', id: 'tt1', nombre: 'test_nombre', password: '1234567A', turno: 'mañana' }
    expect(response).to have_http_status(:unprocessable_entity)
    post = JSON.parse(response.body)
    expect(post['error']).to eq(["La contraseña debe contener al menos 1 caracter especial(@#$%&*)"])

  end
  scenario 'Sends a post request to create a bedel and password fails condition digit' do
    post 'http://localhost:3000/bedeles', params: { apellido: 'test_apellido', id: 'tt1', nombre: 'test_nombre', password: 'A&BBBBBB', turno: 'mañana' }
    expect(response).to have_http_status(:unprocessable_entity)
    post = JSON.parse(response.body)
    expect(post['error']).to eq(["La contraseña debe contener al menos 1 dígito"])
  end
  scenario 'Sends a post request to create a bedel and password fails condition uppercase' do
    post 'http://localhost:3000/bedeles', params: { apellido: 'test_apellido', id: 'tt1', nombre: 'test_nombre', password: 'a&bb2bbb', turno: 'mañana' }
    expect(response).to have_http_status(:unprocessable_entity)
    post = JSON.parse(response.body)
    expect(post['error']).to eq(["La contraseña debe contener al menos 1 mayúscula"])
  end
  scenario 'Sends a post request to create a bedel and password fails all conditions' do
    post 'http://localhost:3000/bedeles', params: { apellido: 'test_apellido', id: 'tt1', nombre: 'test_nombre', password: 'aaaaaaa', turno: 'mañana' }
    expect(response).to have_http_status(:unprocessable_entity)
    post = JSON.parse(response.body)
    expect(post['error']).to eq(["La contraseña debe contener al menos 1 dígito", "La contraseña debe contener al menos 1 mayúscula", "La contraseña debe contener al menos 1 caracter especial(@#$%&*)", "La contraseña debe tener por lo menos 8 caracteres"])
  end
end
