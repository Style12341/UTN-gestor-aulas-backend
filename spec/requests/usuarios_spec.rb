require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  before do
    nombre = Faker::Name.first_name
    apellido = Faker::Name.last_name
    @id = "#{nombre[0]}#{apellido[0]}#{rand(1000..9999)}"
    Bedel.create!(id: @id, turno: Bedel.turnos.keys.sample, nombre:,
                  apellido:, password: '12345678')
    Administrador.create(id: 'admin', password: 'admin')
  end
  scenario 'Login with valid admin credentials' do
    post login_url, params: { id: 'admin', password: 'admin' }
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body.keys).to contain_exactly('id', 'type')
    expect(body['id']).to eq('admin')
    expect(body['type']).to eq('Administrador')
  end
  scenario 'Login with valid bedel credentials' do
    post login_url, params: { id: @id, password: '12345678' }
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body.keys).to contain_exactly('id', 'type', 'turno', 'nombre', 'apellido')
  end
  scenario 'Login with invalid credentials' do
    post login_url, params: { id: "123", password: '12345678' }
    expect(response).to have_http_status(:unauthorized)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    # Check if the response contains the expected keys
    body = JSON.parse(response.body)
    expect(body.keys).to contain_exactly('error')
    expect(body['error']).to eq('Email o contraseña invalida')
  end
end
