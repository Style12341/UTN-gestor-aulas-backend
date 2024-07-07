class ReservaEsporadica < Reserva
  validates :periodicidad, absence: true
  has_many :renglones, class_name: 'RenglonReservaEsporadica', dependent: :destroy, foreign_key: 'reserva_id'
end
