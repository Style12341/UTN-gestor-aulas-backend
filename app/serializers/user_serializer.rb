class UserSerializer < ActiveModel::Serializer
  attributes :id, :turno, :nombre, :apellido
end
