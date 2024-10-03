class ReservaEsporadica < Reserva
  validates :periodicidad, absence: true
  has_many :renglones, class_name: 'RenglonReservaEsporadica', dependent: :destroy, foreign_key: 'reserva_id'
  # Se toman como validos las reservas solicitadas desde el comienzo del año de la fecha dada hasta la fecha dada
  def self.get_overlap_reservas_ids_by_year(año)
    where(año:).pluck(:id)
  end

  def add_renglon(fecha, horario, aula)
    # TODO: Create renglon then add
    r = RenglonReservaEsporadica.new(fecha:, horario:, aula:)
    renglones << r
  end
end
