class ReservaEsporadica < Reserva
  validates :periodicidad, absence: true
  has_many :renglones, class_name: 'RenglonReservaEsporadica', dependent: :destroy, foreign_key: 'reserva_id'
  # Se toman como validos las reservas solicitadas desde el comienzo del año de la fecha dada hasta la fecha dada
  def self.get_valid_reservas_ids_by_year(año)
    where(año:).pluck(:id)
  end
end
