class ReservaPeriodica < Reserva
  enum :periodicidad, anual: 0, cuatrimestre_1: 1, cuatrimestre_2: 2
  validates :periodicidad, presence: true
  has_many :renglones, class_name: 'RenglonReservaPeriodica', dependent: :destroy, foreign_key: 'reserva_id'
end
