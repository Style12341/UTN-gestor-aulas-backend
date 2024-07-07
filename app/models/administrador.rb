class Administrador < Usuario
  validates :nombre, presence: false
  validates :apellido, presence: false
  validates :turno, presence: false
end
