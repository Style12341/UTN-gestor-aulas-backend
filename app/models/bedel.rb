class Bedel < Usuario
  enum :turno, todos: 0, mañana: 1, tarde: 2, noche: 3
  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :turno, presence: true
  has_many :reservas, class_name: 'Reserva', dependent: :destroy, foreign_key: 'bedel_id'
  has_many :reservas_periodicas, class_name: 'ReservaPeriodica', dependent: :destroy, foreign_key: 'bedel_id'
  has_many :reservas_esporadicas, class_name: 'ReservaEsporadica', dependent: :destroy, foreign_key: 'bedel_id'
end
