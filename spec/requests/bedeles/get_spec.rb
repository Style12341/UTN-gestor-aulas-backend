require 'rails_helper'

RSpec.describe 'Bedeles', type: :request do
  before do
    4.times do |i|
      nombre = "test_nombre_#{i}"
      apellido = "test_apellido_#{i}"
      id = "#{nombre[0]}#{apellido[0]}#{i}"
      Bedel.create!(id:, turno: Bedel.turnos.keys[i], nombre:,
                    apellido:, password: '12&A45678')
    end
    4.times do |i|
      nombre = "prueba_nombre_#{i}"
      apellido = "prueba_apellido_#{i}"
      id = "#{nombre[0]}#{apellido[0]}#{i}"
      Bedel.create!(id:, turno: Bedel.turnos.keys[i], nombre:,
                    apellido:, password: '12&A45678')
    end
  end

  scenario 'Get all bedeles' do
    get 'http://localhost:3000/bedeles'
    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.size).to eq(8)
  end
  scenario 'Get bedeles with turno todos' do
    get 'http://localhost:3000/bedeles?turno=todos'
    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.size).to eq(2)
  end
  scenario 'Get bedeles with turno mañana' do
    get Addressable::URI.parse('http://localhost:3000/bedeles?turno=mañana').display_uri.to_s
    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.size).to eq(2)
  end
  scenario 'Get bedeles with turno tarde' do
    get 'http://localhost:3000/bedeles?turno=tarde'
    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.size).to eq(2)
  end
  scenario 'Get bedeles with turno noche' do
    get 'http://localhost:3000/bedeles?turno=noche'
    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.size).to eq(2)
  end
  scenario 'Get bedeles with apellido beginning with test' do
    get 'http://localhost:3000/bedeles?apellido=test'
    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.size).to eq(4)
  end
  scenario 'Get bedeles with apellido beginning with prueba' do
    get 'http://localhost:3000/bedeles?apellido=prueba'
    expect(response).to have_http_status(:success)
    bedeles = JSON.parse(response.body)
    expect(bedeles.size).to eq(4)
  end
end
