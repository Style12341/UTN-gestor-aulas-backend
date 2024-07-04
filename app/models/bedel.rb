class Bedel < User
  enum :turno, { todos: 0, mañana: 1, tarde: 2, noche: 3 }
  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :turno, presence: true
end
