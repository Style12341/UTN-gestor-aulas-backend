class ValidacionesController < ApplicationController
  def self.validate_password(password)
    errors = []

    if password.present?
      errors << 'La contraseña debe contener al menos 1 dígito' unless password.match(/\d/)

      errors << 'La contraseña debe contener al menos 1 mayúscula' unless password.match(/[A-Z]/)

      errors << "La contraseña debe contener al menos 1 caracter especial(@\#$%&*)" unless password.match(/[@#$%&*]/)

      errors << 'La contraseña debe tener por lo menos 8 caracteres' if password.length < 8
    end

    errors
  end

  # Returns a list of strings specifying each restriction
  def password
    validaciones = []
    validaciones << 'La contraseña debe contener al menos 1 dígito'
    validaciones << 'La contraseña debe contener al menos 1 mayúscula'
    validaciones << "La contraseña debe contener al menos 1 caracter especial(@#$%&*)"
    validaciones << 'La contraseña debe tener por lo menos 8 caracteres'
    render json: validaciones
  end
end
