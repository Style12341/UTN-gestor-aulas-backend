class UsuariosController < ApplicationController
  def create
    user = Usuario.find_by(id: params[:id])
    if user&.authenticate(params[:password])
      if user.type == 'Administrador'
        render json: { id: user.id, type: user.type }, status: :created
      else
        render json: { id: user.id, type: user.type, turno: user.turno, nombre: user.nombre, apellido: user.apellido },
               status: :created
      end
    else
      render json: { error: 'Email o contraseña invalida' }, status: :unauthorized
    end
  end
end
