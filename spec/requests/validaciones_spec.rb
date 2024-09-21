require 'rails_helper'

RSpec.describe "Validaciones", type: :request do
  scenario 'Sends a get request to get all the validaciones for password' do
    get 'http://localhost:3000/validaciones/password'

    expect(response).to have_http_status(:success)
    validaciones = JSON.parse(response.body)
    expect(validaciones).to eq(["La contraseña debe contener al menos 1 dígito", "La contraseña debe contener al menos 1 mayúscula", "La contraseña debe contener al menos 1 caracter especial(@#$%&*)", "La contraseña debe tener por lo menos 8 caracteres"])
  end
end
