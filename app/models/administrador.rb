class Administrador < Usuario
  validates :nombre, absence: true
  validates :apellido, absence: true
  validates :turno, absence: true
  validates :deleted_at, absence: true
end
